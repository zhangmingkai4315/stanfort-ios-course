//
//  ViewController.swift
//  Concentration
//
//  Created by mingkai on 31/05/2019.
//  Copyright © 2019 mingkai. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private lazy var game  = Concentration(numberOfPairsOfCards:numberOfPairsOfCards)
    
    var numberOfPairsOfCards: Int{
        return (cardButtons.count+1)/2
    }
    
    private(set) var flipCount = 0{
        didSet{
           updateFlipCountLabel()
        }
    }
    
    private func updateFlipCountLabel(){
        let attributes : [NSAttributedStringKey: Any] = [
            .strokeWidth: 5.0,
            .strokeColor: UIColor.yellow,
            ]
        let attributedString = NSAttributedString(string: "Flips: \(flipCount)", attributes: attributes)
        flipCounterLabel.attributedText=attributedString
    }
    
    @IBOutlet private var cardButtons: [UIButton]!
    @IBOutlet private weak var flipCounterLabel: UILabel!{
        didSet{
            updateFlipCountLabel()
        }
    }
    @IBAction private func touchCard(_ sender: UIButton) {
        if let cardNumber = cardButtons.index(of: sender){
            flipCount += 1
            game.chooseCard(at: cardNumber)
            updateViewFromModal()
        }else{
            print("some card not in cardButtons")
        }

    }
    
    private func updateViewFromModal() {
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
    private var emojiChoices : String = "🐝🙊😀🕷🦈🌳"
    
    private var emoji = [Card : String]()
    
    private func emoji(for card:Card)->String{
        if emoji[card] == nil, emojiChoices.count > 0{
            let randomStringIndex = emojiChoices.index(emojiChoices.startIndex, offsetBy: emojiChoices.count.arc4random)
            emoji[card] = String(emojiChoices.remove(at: randomStringIndex))
        }
        return emoji[card] ?? "?"
    }
}

extension Int{
    var arc4random: Int{
        if self > 0{
            return Int(arc4random_uniform(UInt32(self)))
        }else if self < 0{
            return -Int(arc4random_uniform(UInt32(abs(self))))
        } else {
            return 0
        }
    }
}

