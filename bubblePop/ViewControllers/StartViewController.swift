//
//  ViewController.swift
//  bubblePop
//
//  Created by 🐑 on 2021/1/12.
//  Copyright © 2021 🐑. All rights reserved.
//

import UIKit

class StartViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    var name: String = ""
    var initTime = 60
    var initBubbles = 15
    
    //Empty player name alert
    @IBAction func onSettingPageClick(_ sender: UIButton) {
        if nameTextField.text!.isEmpty {
            let nameAlert = UIAlertController(title: "Empty", message: "Please enter the player name", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Okay", style: .cancel, handler: nil)
            nameAlert.addAction(okAction)
            self.present(nameAlert, animated: true, completion: nil)
        }
    }
    
    @IBAction func saveName(_ sender: UITextField) {
            name = sender.text!
            let defaults = UserDefaults.standard
            defaults.set(name, forKey: "PlayerName")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UserDefaults.standard.set(initTime, forKey: "GameDuration")
        UserDefaults.standard.set(initBubbles, forKey: "Bubbles")
    }
    
}
