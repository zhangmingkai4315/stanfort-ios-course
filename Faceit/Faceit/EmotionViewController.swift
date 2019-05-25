//
//  EmotionViewController.swift
//  Faceit
//
//  Created by 明凯张 on 2019/5/16.
//  Copyright © 2019 明凯张. All rights reserved.
//

import UIKit

class EmotionViewController: UIViewController {

    private let emotionFaces : Dictionary<String, FacialExpression> = [
        "sad" : FacialExpression(eyes: .closed, mouth: .frown),
        "happy" : FacialExpression(eyes: .open, mouth: .smile),
        "worried" : FacialExpression(eyes: .open, mouth: .smirk),
    ]
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationViewController = segue.destination
        
        if let faceViewController = destinationViewController as? FaceViewController{
            if let identifier = segue.identifier{
                if let expression = emotionFaces[identifier] {
                    faceViewController.expression = expression
                }
            }
        }
    }
}
