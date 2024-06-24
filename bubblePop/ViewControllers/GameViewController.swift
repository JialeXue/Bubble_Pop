//
//  ViewController.swift
//  bubblePop
//
//  Created by 🐑 on 2021/1/12.
//  Copyright © 2021 🐑. All rights reserved.
//


import UIKit

class GameViewController: UIViewController {

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var remainingTimeLabel: UILabel!
    @IBOutlet weak var currentScore: UILabel!
    @IBOutlet weak var highScore: UILabel!
    
    var name: String = ""
    var timer = Timer()
    var remainingTime = 60
    var bubbleCache = [UIButton]()
    var width: CGFloat = UIScreen.main.bounds.width
    var height: CGFloat = UIScreen.main.bounds.height
    var radius: CGFloat = UIScreen.main.bounds.width / 10
    var lastScore:Double = 0
    var roundScore:Double = 0
    var playerHistory:Dictionary = [String:Double]()
    var savedHistory:Dictionary? = [String:Double]()
    var sortedHistoryArray = [(key:String,value:Double)]()
    var playerName:String = ""
    var maxNumber = 15
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Retrieve Data from UserDefault and Sort data
        playerName = UserDefaults.standard.string(forKey: "PlayerName")!
        //print(playerName)
        savedHistory = UserDefaults.standard.dictionary(forKey: "ScoreBoard") as? Dictionary<String,Double>
        if savedHistory != nil {
            playerHistory = savedHistory!
            sortedHistoryArray = playerHistory.sorted(by: {$0.value > $1.value}) //descending
            highScore.text = "\(sortedHistoryArray[0].value)"
        }
        
        remainingTime = UserDefaults.standard.integer(forKey: "GameDuration")
        remainingTimeLabel.text = String(remainingTime)
        currentScore.text = String(roundScore)
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true)  { [self]
            time in
            self.counter()
            self.randomRemove()
            self.generateBubbles()
        }
        
    }
    
    func counter() {
        remainingTime -= 1
        remainingTimeLabel.text = String(remainingTime)
        if remainingTime == 0 {
            timer.invalidate()
            saveScore()
            let alertController = UIAlertController(title: "Gameover",
                            message: "Well done \(playerName) ! You've got \(roundScore) points. Please check the ranking list", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Dismiss", style: .cancel, handler: {
                action in
                self.navigationController?.popToRootViewController(animated: true)
            })
            let okAction: UIAlertAction = UIAlertAction(title: "OK", style: .default) { action -> Void in

            //Redirect to socreViewControler
            let newVC = self.storyboard?.instantiateViewController(identifier: "newvc") as! ScoreViewController
            self.navigationController?.pushViewController(newVC,animated: true)
                
            }
            
            alertController.addAction(cancelAction)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    //Create frame for rendering UIButton
    func generateFrame() -> CGRect{
        let rectRangeX = CGFloat.random(in: radius...(width - 2 * radius))
        let rectRangeY = CGFloat.random(in: 200...(height - 2 * radius))
        let rectRangeW = CGFloat(2 * radius)
        let rectRangeH = CGFloat(2 * radius)
        return CGRect(x: rectRangeX,y: rectRangeY,width: rectRangeW,height: rectRangeH)
    }
    
    //Rendering UIButton
    func renderBubble() -> UIButton{
        
        let bubble = UIButton.init(frame: generateFrame())
        bubble.layer.cornerRadius = CGFloat(radius)
        let possibility = Int.random(in: 0..<100)
        
        switch possibility {
        case 0...39:
            bubble.backgroundColor =  #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
        case 40...69:
            bubble.backgroundColor =  #colorLiteral(red: 1, green: 0.2527923882, blue: 1, alpha: 1)
        case 70...84:
            bubble.backgroundColor =  #colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1)
        case 85...94:
            bubble.backgroundColor =  #colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1)
        case 95...99:
            bubble.backgroundColor =  #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        default:
            print("error")
        }
        return bubble
    }
    
    //Check overlap
    func intersectCheck(_ bubble: UIButton) -> Bool{
        for target in bubbleCache{
            if target.frame.intersects(bubble.frame){
                return true
            }
        }
        return false
    }
    
    //Create bubble within settings
    func generateBubbles(){
        maxNumber = UserDefaults.standard.integer(forKey: "Bubbles")
        let rangeOfNew = Int.random(in: 1...(maxNumber - bubbleCache.count))
        var i = 0
        while i < rangeOfNew {
            let newBubble = renderBubble()
            if !intersectCheck(newBubble){
                bubbleCache += [newBubble]
                newBubble.addTarget(self, action: #selector(bubbleClick), for: .touchDown)
                animationIn(newBubble)
                self.view.addSubview(newBubble)
                i += 1
            }
        }
    }
    
    //Remove bubbles with random number
    func randomRemove(){
        if bubbleCache.count>0 {
            //print("count:\(bubbleCache.count)")
            let randomIndex = Int.random(in: 1...bubbleCache.count)
            //print("rI:\(randomIndex)")
            var i = 0
            while i < randomIndex{
            bubbleCache[0].removeFromSuperview()
            bubbleCache.remove(at: 0)
            i += 1
            //print("i:\(i)")
            }
        }
    }
    
    //function for bubble being tapped
    @IBAction func bubbleClick(_ bubbleClicked: UIButton){
        bubbleClicked.removeFromSuperview()
        animationOut(bubbleClicked)
        var thisBubbleScore:Double = 0
        switch bubbleClicked.backgroundColor{
            case #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1):
                thisBubbleScore = 1
            case #colorLiteral(red: 1, green: 0.2527923882, blue: 1, alpha: 1):
                thisBubbleScore = 2
            case #colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1):
                thisBubbleScore = 5
            case #colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1):
                thisBubbleScore = 8
            case #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1):
                thisBubbleScore = 10
            default:
            print("error at tap")
        }
        
        //Double click on same color
        if thisBubbleScore == lastScore {
            roundScore += 1.5 * thisBubbleScore
        } else {
            roundScore += thisBubbleScore
        }
        lastScore = thisBubbleScore
        currentScore.text = String(roundScore)
        //Display the correct high score
        if savedHistory == nil {
            highScore.text = "\(roundScore)"
        }else if roundScore > sortedHistoryArray[0].value {
            highScore.text = "\(roundScore)"
        }else if roundScore < sortedHistoryArray[0].value {
            highScore.text = "\(sortedHistoryArray[0].value)"
        }
    }
    
    func saveScore() {
        if savedHistory == nil {
            playerHistory.updateValue(roundScore, forKey: "\(playerName)")
            UserDefaults.standard.set(playerHistory, forKey: "ScoreBoard")
        } else if savedHistory!.keys.contains("\(playerName)") {
            if savedHistory!["\(playerName)"]! < roundScore {
                playerHistory.updateValue(roundScore, forKey: "\(playerName)")
                UserDefaults.standard.set(playerHistory, forKey: "ScoreBoard")
            }
        } else {
            playerHistory.updateValue(roundScore, forKey: "\(playerName)")
            UserDefaults.standard.set(playerHistory, forKey: "ScoreBoard")
        }
    }
    
    func animationOut(_ button:UIButton){
        let motion = CABasicAnimation(keyPath: "opacity")
        motion.duration = 0.5
        motion.fromValue = 1
        motion.toValue = 0
        button.layer.add(motion, forKey: nil)
    }
    
    func animationIn(_ button:UIButton){
        let motion = CABasicAnimation(keyPath: "opacity")
        motion.duration = 0.5
        motion.fromValue = 0
        motion.toValue = 1
        button.layer.add(motion, forKey: nil)
    }
    

}

