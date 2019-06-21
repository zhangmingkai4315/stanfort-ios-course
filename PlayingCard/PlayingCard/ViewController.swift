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
    @IBOutlet private var cardViews : [PlayingCardView]!
    
    lazy var animator = UIDynamicAnimator(referenceView: view)
    lazy var cardBehavoir = CardBehavior(in: animator)
    
//    @IBOutlet weak var playingCardView: PlayingCardView!{
//        didSet{
//            let swipe = UISwipeGestureRecognizer(target: self, action: #selector(nextCard))
//            swipe.direction = [.left, .right]
//            playingCardView.addGestureRecognizer(swipe)
//
//            let pich = UIPinchGestureRecognizer(target: playingCardView, action: #selector(PlayingCardView.adjustFaceCardScale(byHandlingGesureRecognizedBy: )))
//            playingCardView.addGestureRecognizer(pich)
//        }
//    }
    var lastChosenCardView : PlayingCardView?
    
    @IBAction func flipCard(_ sender: UITapGestureRecognizer){
        switch sender.state {
        case .ended:
            if let chosenCardView = sender.view as? PlayingCardView{
                cardBehavoir.removeItem(chosenCardView)
                lastChosenCardView = chosenCardView
                UIView.transition(
                    with: chosenCardView,
                    duration: 1.0,
                    options: [.transitionFlipFromLeft],
                    animations: {
                        chosenCardView.isFaceUp = !chosenCardView.isFaceUp
                    },
                    completion:{ finished in
                        let cardsToAnimation = self.faceUpCardViews
                        if self.faceUpCardViewMatch {
                            UIViewPropertyAnimator.runningPropertyAnimator(
                                withDuration: 1.0, delay: 0, options: [], animations: {
                                    cardsToAnimation.forEach{
                                        $0.transform = CGAffineTransform.identity.scaledBy(x: 3.0, y: 3.0)
                                    }
                            },completion: { position in
                                UIViewPropertyAnimator.runningPropertyAnimator(
                                    withDuration: 2.0, delay: 0, options: [],
                                    animations: {
                                        cardsToAnimation.forEach{
                                            $0.transform = CGAffineTransform.identity.scaledBy(x: 0.1, y: 0.1)
                                            $0.alpha = 0
                                        }
                                    },completion: { position in
                                    cardsToAnimation.forEach{ view in
                                        view.isHidden = true
                                        view.alpha = 1
                                        view.transform = .identity
                                    }
                                })
                            })
                        } else if cardsToAnimation.count >= 2 {
                            if chosenCardView == self.lastChosenCardView {
                                cardsToAnimation.forEach{ cardView in
                                    UIView.transition(
                                        with: cardView,
                                        duration: 1,
                                        options: [UIViewAnimationOptions.transitionFlipFromLeft],
                                        animations: {
                                            cardView.isFaceUp = false
                                    },completion: { finished in
                                        self.cardBehavoir.addItem(cardView)
                                    }
                                    )
                                }
                            }
                          
                        }else{
                            if !chosenCardView.isFaceUp{
                                self.cardBehavoir.addItem(chosenCardView)
                            }
                        }
                    }
                )
                
            }
        default:
            break
        }
    }
//    @objc func nextCard(){
//        if let card = deck.draw(){
//            playingCardView.rank = card.rank.order
//            playingCardView.suit = card.suit.rawValue
//        }
//    }
    
    private var faceUpCardViews : [PlayingCardView]{
        return cardViews.filter{ $0.isFaceUp &&
            !$0.isHidden &&
            $0.transform != CGAffineTransform.identity.scaledBy(x: 3.0, y: 3.0) &&
            $0.alpha == 1
        }
    }
    
    private var faceUpCardViewMatch: Bool{
        return faceUpCardViews.count == 2 &&
        faceUpCardViews[0].rank == faceUpCardViews[1].rank &&
        faceUpCardViews[0].suit == faceUpCardViews[1].suit
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        var cards = [PlayingCard]()
        for _ in 1...((cardViews.count+1)/2){
            let card = deck.draw()!
            cards += [card, card]
        }
        for cardView in cardViews{
            cardView.isFaceUp = false
            let card = cards.remove(at: cards.count.arc4random)
            cardView.rank  = card.rank.order
            cardView.suit = card.suit.rawValue
            cardView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(flipCard(_:))))
            cardBehavoir.addItem(cardView)
        }
    }
    
}

extension CGFloat{
    public static func random(lower: Float = 0, _ upper: Float = 100) -> CGFloat {
        return CGFloat((Float(arc4random()) / 0xFFFFFFFF) * (upper - lower) + lower)
    }
}
