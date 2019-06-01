//
//  ViewController.swift
//  Concentration
//
//  Created by mingkai on 31/05/2019.
//  Copyright © 2019 mingkai. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    lazy var game  = Concentration(numberOfPairsOfCards:(cardButtons.count+1)/2)
    
    var flipCount = 0{
        didSet{
            flipCounterLabel.text="Counter: \(flipCount)"
        }
    }

    
    @IBOutlet var cardButtons: [UIButton]!
    @IBOutlet weak var flipCounterLabel: UILabel!
    @IBAction func touchCard(_ sender: UIButton) {
        if let cardNumber = cardButtons.index(of: sender){
            flipCount += 1
            game.chooseCard(at: cardNumber)
            updateViewFromModal()
        }else{
            print("some card not in cardButtons")
        }

    }
    
    func updateViewFromModal() {
        for index in cardButtons.indices{
            let button = cardButtons[index]
            let card = game.cards[index]
            if card.isFaceUp{
                button.setTitle(emoji(for: card), for: .normal)
                button.backgroundColor=#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            }else{
                button.setTitle("", for: .normal)
                button.backgroundColor=card.isMatched ? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0) : #colorLiteral(red: 1, green: 0.5390133716, blue: 0.0120538998, alpha: 1)
            }
        }
    }
    var emojiChoices : Array<String> = ["🐝","🙊","😀","🕷","🦈","🌳"]
    
    var emoji = [Int:String]()
    
    func emoji(for card:Card)->String{
        if emoji[card.identifier] == nil, emojiChoices.count > 0{
            let random = arc4random_uniform(UInt32(emojiChoices.count))
            emoji[card.identifier] = emojiChoices.remove(at: Int(random))
        }
        return emoji[card.identifier] ?? "?"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}

