//
//  ViewController.swift
//  Concentration
//
//  Created by mingkai on 31/05/2019.
//  Copyright © 2019 mingkai. All rights reserved.
//

import UIKit

class ConcentrationViewController: VCLLoggingViewController {
    
    private lazy var game  = Concentration(numberOfPairsOfCards:numberOfPairsOfCards)
    
    var numberOfPairsOfCards: Int{
        return (visibleCardButtons.count+1)/2
    }
    
    private(set) var flipCount = 0{
        didSet{
           updateFlipCountLabel()
        }
    }
    
    private func updateFlipCountLabel(){
        let attributes : [NSAttributedStringKey: Any] = [
            .strokeWidth: 5.0,
            .strokeColor: UIColor.black,
            ]
        let attributedString = NSAttributedString(string: traitCollection.verticalSizeClass == .compact ? "Counter \n \(flipCount)":"Counter :\(flipCount)", attributes: attributes)
        flipCounterLabel.attributedText=attributedString
    }
    // 更新视图的时候切换
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        updateFlipCountLabel()
    }
    
    @IBOutlet private var cardButtons: [UIButton]!
    
    private var visibleCardButtons: [UIButton]!{
        return cardButtons?.filter{!$0.superview!.isHidden}
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateViewFromModal()
    }
    
    @IBOutlet private weak var flipCounterLabel: UILabel!{
        didSet{
            updateFlipCountLabel()
        }
    }
    @IBAction private func touchCard(_ sender: UIButton) {
        if let cardNumber = visibleCardButtons.index(of: sender){
            flipCount += 1
            game.chooseCard(at: cardNumber)
            updateViewFromModal()
        }else{
            print("some card not in cardButtons")
        }

    }
    
    private func updateViewFromModal() {
        if visibleCardButtons != nil{
            for index in visibleCardButtons.indices{
                let button = visibleCardButtons[index]
                let card = game.cards[index]
                if card.isFaceUp{
                    button.setTitle(emoji(for: card), for: .normal)
                    button.backgroundColor=#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                }else{
                    button.setTitle("", for: .normal)
                    button.backgroundColor=card.isMatched ? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0) : #colorLiteral(red: 0, green: 0.5690457821, blue: 0.5746168494, alpha: 1)
                }
            }
        }
    }
    
    var theme : String?{
        didSet{
            emojiChoices = theme ?? ""
            emoji = [:]
            updateViewFromModal()
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

