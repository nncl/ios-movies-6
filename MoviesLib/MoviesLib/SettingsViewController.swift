//
//  SettingsViewController.swift
//  MoviesLib
//
//  Created by Usuário Convidado on 22/03/17.
//  Copyright © 2017 EricBrito. All rights reserved.
//

import UIKit
import CoreMotion // Sensores do device

enum SettingsType : String {
    case colorscheme = "colorscheme"
    case autoplay = "autoplay"
}

class SettingsViewController: UIViewController {

    @IBOutlet weak var scColorScheme: UISegmentedControl!
    @IBOutlet weak var swAutoPlay: UISwitch!
    
    @IBOutlet weak var ivBackground: UIImageView!
    @IBOutlet weak var pickerView: UIPickerView!
    
    var motionManager = CMMotionManager()
    var dataSource = [
        "Arroz",
        "Feijão",
        "Batata",
        "Macarrão",
        "Ovo"
    ]
    
    @IBAction func changeColorScheme(_ sender: UISegmentedControl) {
        UserDefaults.standard.set(sender.selectedSegmentIndex, forKey: SettingsType.colorscheme.rawValue)
    }
    
    @IBAction func changeAutoplay(_ sender: UISwitch) {
        UserDefaults.standard.set(sender.isOn, forKey: SettingsType.autoplay.rawValue)
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
        // Detectar se device tem acelerometro e giroscopio
        
        if motionManager.isDeviceMotionAvailable {
            // Atualizar na main thread
            motionManager.startDeviceMotionUpdates(to: OperationQueue.main, withHandler: {
                (data: CMDeviceMotion?, error: Error?) in
                
                if error == nil {
                    if let data = data {
                        let angle = atan2(data.gravity.x, data.gravity.y) - M_PI
                        self.ivBackground.transform = CGAffineTransform(rotationAngle: CGFloat(angle))
                    }
                }
                
            })
        }
        
        // pickerView.selectedRow(inComponent: 0) // Recupera o item selecionado no picker view
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Item do segmento selecionado
        scColorScheme.selectedSegmentIndex = UserDefaults.standard.integer(forKey: SettingsType.colorscheme.rawValue)
        
        swAutoPlay.setOn(UserDefaults.standard.bool(forKey: SettingsType.autoplay.rawValue), animated: false)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.becomeFirstResponder()
    }
}

extension SettingsViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
    }
}

extension SettingsViewController: UIPickerViewDelegate {
    
    // Populamos os valores que aparecerão no PickerView
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return dataSource[row]
    }
    
    //
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print("Acabaram de comer ", dataSource[row])
    }
    
}

extension SettingsViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        // Quantos componentes existem no pickerview = colunas; like date
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataSource.count
    }
}




