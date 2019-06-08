//
//  Concentration.swift
//  Concentration
//
//  Created by mingkai on 31/05/2019.
//  Copyright © 2019 mingkai. All rights reserved.
//

import Foundation
struct Card : Hashable{
    var isFaceUp = false
    var isMatched = false
    private var identifier : Int
    
    var hashValue: Int{
        return identifier
    }
    
    static func ==(lhs: Card, rhs: Card)->Bool{
        return lhs.identifier == rhs.identifier
    }
    
    private static var idFactory = 0
    private static func getUniqueID()->Int{
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


struct Concentration{
    private(set) var cards = Array<Card>()
    private var indexOfOneAndOnlyFaceUpCard: Int?{
        get {
            return cards.indices.filter{cards[$0].isFaceUp}.oneAndOnly
        }
        set {
            for index in cards.indices{
                cards[index].isFaceUp = (index == newValue)
            }
        } 
    }
    
    mutating func chooseCard(at index:Int){
        assert(cards.indices.contains(index),"Concentration.chooseCard(at:\(index)) chosen index not the cards")
        if !cards[index].isMatched{
            if let matchIndex = indexOfOneAndOnlyFaceUpCard, matchIndex != index{
                if cards[matchIndex] == cards[index]{
                    cards[matchIndex].isMatched = true
                    cards[index].isMatched = true
                }
                cards[index].isFaceUp = true
            }else{
                indexOfOneAndOnlyFaceUpCard = index
            }
        }
    }
    init(numberOfPairsOfCards :Int){
        assert(numberOfPairsOfCards > 0, "Concentration:init(numberOfPairsOfCards :\(numberOfPairsOfCards)) must greater than 0")
        for _ in 1...numberOfPairsOfCards{
           let card = Card()
            cards.append(card)
            cards.append(card)
        }
        // shuffer the cards using extension
        cards.shuffer()
    }
}


extension Collection {
    var oneAndOnly : Element?{
        return count == 1 ? first : nil
    }
}

