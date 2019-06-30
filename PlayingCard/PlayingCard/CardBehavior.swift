//
//  CardBehavior.swift
//  PlayingCard
//
//  Created by mingkai on 2019/6/21.
//  Copyright © 2019年 mingkai. All rights reserved.
//

import UIKit

class CardBehavior: UIDynamicBehavior {
    
    override init(){
        super.init()
        addChildBehavior(collisionBehavior)
        addChildBehavior(itemBehavior)
        addChildBehavior(gravitiBehavior)
    }
    
    convenience init(in animator:UIDynamicAnimator){
        self.init()
        animator.addBehavior(self)
    }
    
    lazy var collisionBehavior:UICollisionBehavior = {
        let behavior = UICollisionBehavior()
        behavior.translatesReferenceBoundsIntoBoundary = true
        return behavior
    }()
    
    lazy var itemBehavior : UIDynamicItemBehavior = {
        let behavior = UIDynamicItemBehavior()
        behavior.allowsRotation = false
        behavior.elasticity = 1.0
        behavior.resistance = 0
        return behavior
    }()

    private func push(_ item: UIDynamicItem) {
        let push = UIPushBehavior(items: [item], mode: .instantaneous)
        push.angle = CGFloat.random(lower: 0.0, (Float(2.0*CGFloat.pi)))
        push.magnitude = CGFloat.random(lower: 0.0, 1.0 ) + CGFloat.random(lower: 0.0, 1.0 )
        push.action =  { [unowned push, weak self] in
            self?.removeChildBehavior(push)
        }
        addChildBehavior(push)
    }
    func addItem(_ item: UIDynamicItem){
        collisionBehavior.addItem(item)
        itemBehavior.addItem(item)
        gravitiBehavior.addItem(item)
        push(item)
    }
    func removeItem(_ item: UIDynamicItem){
        collisionBehavior.removeItem(item)
        itemBehavior.removeItem(item)
        gravitiBehavior.removeItem(item)
    }
    
    public var gravitiBehavior : UIGravityBehavior={
        let behavior = UIGravityBehavior()
        behavior.magnitude = 0
        return behavior
    }()
}
