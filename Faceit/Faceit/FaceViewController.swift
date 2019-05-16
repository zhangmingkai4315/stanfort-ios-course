//
//  ViewController.swift
//  Faceit
//
//  Created by 明凯张 on 2019/5/4.
//  Copyright © 2019 明凯张. All rights reserved.
//

import UIKit

class FaceViewController: UIViewController {

    @IBOutlet weak var faceView: FaceView!{
        didSet{
            let handler = #selector(FaceView.changeScale(byReactinTo:))
            let pinchRecognizer = UIPinchGestureRecognizer(target: faceView, action: handler)
            faceView.addGestureRecognizer(pinchRecognizer)
            
            
            let tapRecongizer = UITapGestureRecognizer(target: self, action: #selector(toggleEyes(byReactingTo:)))
            tapRecongizer.numberOfTapsRequired = 1
            faceView.addGestureRecognizer( tapRecongizer )
            
            let swipeDownReconginzer = UISwipeGestureRecognizer(target: self, action: #selector(decreaseHappiness))
            swipeDownReconginzer.direction = .down
            faceView.addGestureRecognizer(swipeDownReconginzer)
            let swipeUpReconginzer = UISwipeGestureRecognizer(target: self, action: #selector(increaseHappiness))
            swipeUpReconginzer.direction = .up
            faceView.addGestureRecognizer(swipeUpReconginzer)
            updateUI()
        }
    }
    
    
    @objc func increaseHappiness(){
        expression = expression.happier
    }
    
    @objc func decreaseHappiness(){
        expression = expression.sadder
    }
    
    
    @objc func toggleEyes(byReactingTo tapRecongizer:UITapGestureRecognizer){
        if tapRecongizer.state == .ended{
            let eyes : FacialExpression.Eyes = (expression.eyes == .closed) ? .open : .closed
            expression = FacialExpression(eyes: eyes, mouth: expression.mouth)
        }
    }
    
    
    var expression = FacialExpression(eyes: .open, mouth: .grin){
        didSet{
            updateUI()
        }
    }
    
    private func updateUI(){
        switch expression.eyes {
        case .open:
            faceView?.eyeOpen = true
        case .closed:
            faceView?.eyeOpen = false
        case .squinting:
            faceView?.eyeOpen = false
        }
        
        faceView?.mouthCurvature = mouthCurvatures[expression.mouth] ?? 0.0
    }

    private let mouthCurvatures = [
        FacialExpression.Mouth.grin:0.5,
        FacialExpression.Mouth.frown: -1.0,
        FacialExpression.Mouth.smile: 1.0,
        FacialExpression.Mouth.neutral: 0.0,
        FacialExpression.Mouth.smirk: -0.5,
    ]
}

