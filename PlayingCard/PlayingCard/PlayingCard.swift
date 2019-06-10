//
//  PlayingCard.swift
//  PlayingCard
//
//  Created by mingkai on 2019/6/10.
//  Copyright © 2019年 mingkai. All rights reserved.
//

import Foundation

struct PlayingCard :CustomStringConvertible {
    var description: String{
        return "\(suit) \(rank) "
    }
    
    var suit: Suit
    var rank: Rank
    
    enum Suit{
        case spades
        case hearts
        case diamonds
        case clubs
        
        static var all:[Suit]{
            return [Suit.spades,Suit.hearts,Suit.diamonds, Suit.clubs]
        }
    }
    
    enum Rank {
        case ace
        case face(String)
        case numeric(Int)
        // 允许使用计算属性来获得数据
        var order: Int{
            switch self {
            case .ace:
                return 1
            case .numeric(let pips):
                return pips
            case .face(let kind) where kind == "J": return 11
            case .face(let kind) where kind == "Q": return 12
            case .face(let kind) where kind == "K": return 13
            default:
                return 0
            }
        }
        static var all : [Rank]{
            var allRanks = [Rank.ace]
            for pips in 2...10 {
                allRanks.append(Rank.numeric(pips))
            }
            allRanks+=[Rank.face("J"),Rank.face("Q"),Rank.face("K")]
            return allRanks
        }
    }
}

