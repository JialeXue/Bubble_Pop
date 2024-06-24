//
//  ViewController.swift
//  bubblePop
//
//  Created by 🐑 on 2021/1/12.
//  Copyright © 2021 🐑. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController {
    
    var timeStatus:Int = 60
    var bubbleStatus:Int = 15

    @IBOutlet weak var timeSetting: UILabel!
    @IBOutlet weak var bubbleSetting: UILabel!
    @IBOutlet weak var timeSliderValue: UISlider!
    @IBOutlet weak var bubbleSliderValue: UISlider!
    
    @IBAction func timeSlider(_ sender: UISlider) {
        timeStatus = Int(sender.value)
        timeSetting.text = "\(timeStatus)"
        let _default = UserDefaults.standard
        _default.set(timeStatus, forKey:"GameDuration")
    }
    
    @IBAction func bubbleSlider(_ sender: UISlider) {
        bubbleStatus = Int(sender.value)
        bubbleSetting.text = "\(bubbleStatus)"
        let _default = UserDefaults.standard
        _default.set(bubbleStatus, forKey:"Bubbles")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UserDefaults.standard.set(timeStatus, forKey:"GameDuration")
        UserDefaults.standard.set(bubbleStatus, forKey:"Bubbles")
        timeSliderValue.value = Float(timeStatus)
        bubbleSliderValue.value = Float(bubbleStatus)
    }
    

}

