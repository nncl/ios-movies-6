//
//  SettingsViewController.swift
//  MoviesLib
//
//  Created by Usuário Convidado on 22/03/17.
//  Copyright © 2017 EricBrito. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var scColorScheme: UISegmentedControl!
    @IBOutlet weak var swAutoPlay: UISwitch!
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.becomeFirstResponder()
    }
    
    @IBAction func changeColor(_ sender: UISwitch) {
        UserDefaults.standard.set(sender.isOn, forKey: "color")
    }
}

extension SettingsViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
    }
}






