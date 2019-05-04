//
//  FaceView.swift
//  Faceit
//
//  Created by 明凯张 on 2019/5/4.
//  Copyright © 2019 明凯张. All rights reserved.
//

import UIKit

@IBDesignable
class FaceView: UIView {
    var scale : CGFloat = 0.7
    var eyeOpen : Bool = true
    var mouthCurvature : Double = 2.0
    private var skullRadius : CGFloat {
        return min(bounds.size.width, bounds.size.height)/2 * scale
    }
    private var skullCenter : CGPoint{
        return CGPoint(x: bounds.midX, y: bounds.midY)
    }
    
    private enum Eye{
        case left
        case right
    }
    
    private func pathForMouth() -> UIBezierPath{
        let mouthWidth = skullRadius / Ratios.skullRaidusToMouthWidth
        let mouthHeight = skullRadius / Ratios.skullRaidusToMouthHeight
        let mouthOffset = skullRadius / Ratios.skullRaidusToMouthOffset
        
        let mouthRect = CGRect(
            x: skullCenter.x - mouthWidth/2,
            y: skullCenter.y + mouthOffset,
            width: mouthWidth,
            height: mouthHeight
        )
        let start = CGPoint(x: mouthRect.minX, y: mouthRect.midY)
        let end = CGPoint(x: mouthRect.maxX, y: mouthRect.midY)
        let smileOffset = CGFloat(max(-1,min(mouthCurvature,1))) * mouthRect.height
        
        let cp1 = CGPoint(x : start.x + mouthRect.width/3, y : start.y + smileOffset )
        let cp2 = CGPoint(x : end.x - mouthRect.width/3, y : start.y + smileOffset )

        let path = UIBezierPath()
        
        path.move(to: start)
        path.addCurve(to: end, controlPoint1: cp1, controlPoint2: cp2)
        path.lineWidth = 3.0
        return path
    }
    
    
    private func pathForEye(_ eye: Eye) -> UIBezierPath{
        func centerOfEye(_ eye:Eye)->CGPoint{
            let eyeOffset = skullRadius / Ratios.skullRaidusToEyeOffset;
            var eyeCenter = skullCenter
            eyeCenter.y -= eyeOffset
            eyeCenter.x += ((eye == .left) ? -1 : 1) * eyeOffset
            return eyeCenter
        }
        let eyeRadius = skullRadius / Ratios.skullRaidusToEyeRadius
        let eyeCenter = centerOfEye(eye)
        
        let path : UIBezierPath
        if eyeOpen {
            path = UIBezierPath(arcCenter: eyeCenter, radius: eyeRadius, startAngle: 0, endAngle : CGFloat(2*Double.pi), clockwise: false)
        }else{
            path = UIBezierPath()
            path.move(to: CGPoint(x: eyeCenter.x - eyeRadius, y:eyeCenter.y ))
            path.addLine(to: CGPoint(x: eyeCenter.x + eyeRadius, y:eyeCenter.y))
        }
        
        return path
    }
    
    private func pathForSkull() -> UIBezierPath{
        let path = UIBezierPath(arcCenter: skullCenter, radius: skullRadius, startAngle: 0, endAngle:CGFloat(2*Double.pi), clockwise: false)
        path.lineWidth = 2
       
        return path
    }
    
    override func draw(_ rect: CGRect) {
        UIColor.blue.set()
        pathForSkull().stroke()
        pathForEye(Eye.left).stroke()
        pathForEye(Eye.right).stroke()
        pathForMouth().stroke()
    }
    
    private struct Ratios{
        static let skullRaidusToEyeOffset: CGFloat = 3
        static let skullRaidusToEyeRadius: CGFloat = 10
        static let skullRaidusToMouthWidth: CGFloat = 1
        static let skullRaidusToMouthHeight: CGFloat = 3
        static let skullRaidusToMouthOffset: CGFloat = 3
    }
}
