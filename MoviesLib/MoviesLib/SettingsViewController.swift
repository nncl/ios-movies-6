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
    var pickerView: UIPickerView!
    @IBOutlet weak var tfFood: UITextField!
    
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
        
        pickerView = UIPickerView()
        pickerView.backgroundColor = .white
        pickerView.delegate = self
        pickerView.dataSource = self
        //tfFood.inputView = pickerView // Trocando o teclado pelo picker view
        
        let toolBar = UIToolbar(frame: CGRect(x:0,y:0,width:self.view.frame.size.width, height: 44))
        let btCancel = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
        let btSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let btDone = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        toolBar.items = [btCancel, btSpace, btDone] // Adicionando na toolbar
        
        tfFood.inputView = pickerView
        tfFood.inputAccessoryView = toolBar
        
        // tfFood.inputAccessoryView = pickerView // View que auxilia o teclado; add botões de confirmação de escolha de item
        
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
    
    func cancel() {
        tfFood.resignFirstResponder() // Some com o foco do tfield, fazendo o teclado sumir
    }
    
    // Clica no outro botão do toolbar
    func done() {
        tfFood.text = dataSource[pickerView.selectedRow(inComponent: 0)]
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
        tfFood.text = dataSource[row]
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




