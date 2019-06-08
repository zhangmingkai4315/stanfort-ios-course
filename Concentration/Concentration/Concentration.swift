//
//  Concentration.swift
//  Concentration
//
//  Created by mingkai on 31/05/2019.
//  Copyright © 2019 mingkai. All rights reserved.
//

import Foundation
struct Card {
    var isFaceUp = false
    var isMatched = false
    var identifier : Int
    static var idFactory = 0
    static func getUniqueID()->Int{	
        idFactory+=1
        return idFactory
    }
    init(){
        self.identifier = Card.getUniqueID()
    }
}

extension MutableCollection{
    mutating func shuffer(){
        let c = count
        guard c>1 else {
            return
        }
        for (firstUnshufferd, unshufferdCount) in zip(indices, stride(from: c, to: 1, by: -1)){
            let d: Int = numericCast(arc4random_uniform(numericCast(unshufferdCount)))
            let i = index(firstUnshufferd, offsetBy: d)
            swapAt(firstUnshufferd, i)
        }
    }
}


class Concentration{
    var cards = Array<Card>()
    
    var indexOfOneAndOnlyFaceUpCard: Int?
    
    func chooseCard(at index:Int){
        if !cards[index].isMatched{
            if let matchIndex = indexOfOneAndOnlyFaceUpCard, matchIndex != index{
                // check if cards match
                if cards[matchIndex].identifier == cards[index].identifier{
                    cards[matchIndex].isMatched = true
                    cards[index].isMatched = true
                }
                cards[index].isFaceUp = true
                indexOfOneAndOnlyFaceUpCard = nil
            }else{
                // no cards or 2 card are face up
                for flipDownIndex in cards.indices{
                    cards[flipDownIndex].isFaceUp = false
                }
                cards[index].isFaceUp = true
                indexOfOneAndOnlyFaceUpCard = index
            }
        }
    }
    init(numberOfPairsOfCards :Int){
        for _ in 1...numberOfPairsOfCards{
           let card = Card()
            cards.append(card)
            cards.append(card)
        }
        // shuffer the cards using extension
        cards.shuffer()
    }
}
