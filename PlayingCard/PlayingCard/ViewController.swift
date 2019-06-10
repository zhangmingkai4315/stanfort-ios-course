//
//  ViewController.swift
//  PlayingCard
//
//  Created by mingkai on 2019/6/10.
//  Copyright © 2019年 mingkai. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var deck = PlayingCardDeck()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        for _ in 1...10{
            if let card = deck.draw(){
                print("card = \(card)")
            }
        }
    }

}

