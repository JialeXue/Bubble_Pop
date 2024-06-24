//
//  ViewController.swift
//  bubblePop
//
//  Created by 🐑 on 2021/1/12.
//  Copyright © 2021 🐑. All rights reserved.
//

import UIKit

class ScoreViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var tableView: UITableView!
    
    var scores = [String:Double]()
    var playerHistory:Dictionary? = [String:Double]()
    var sortedHistoryArray = [(key:String,value:Double)]()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(editTapped))
        
        //Retrieve Data from UserDefault and Sort data
        playerHistory = UserDefaults.standard.dictionary(forKey: "ScoreBoard") as? Dictionary<String,Double>
        if playerHistory != nil {
            scores = playerHistory!
            sortedHistoryArray = scores.sorted(by: {$0.value > $1.value})
        }
        
    }
    
    //Right navi done button
    @objc func editTapped() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortedHistoryArray.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "myCustumCell")
        let nameLabel = cell!.viewWithTag(11) as! UILabel
        nameLabel.text = sortedHistoryArray[indexPath.row].key
        let scoreLabel = cell!.viewWithTag(22) as! UILabel
        scoreLabel.text = String(sortedHistoryArray[indexPath.row].value)
        
        return cell!
    }
    
    
    
}

