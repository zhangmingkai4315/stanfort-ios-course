//
//  PlayingCardView.swift
//  PlayingCard
//
//  Created by mingkai on 2019/6/11.
//  Copyright © 2019年 mingkai. All rights reserved.
//

import UIKit

class PlayingCardView: UIView {
    var rank: Int = 5 {
        didSet{
            setNeedsDisplay()
            setNeedsLayout()
        }
    }
    var suit : String = "♥"{
        didSet{
            setNeedsDisplay()
            setNeedsLayout()
        }
    }
    var isFaceUp: Bool = true{
        didSet{
            setNeedsDisplay()
            setNeedsLayout()
        }
    }
    
    // 创建居中的字体
    private func centerAttributedString(_ string: String, fontSize:CGFloat) ->NSAttributedString{
        var font = UIFont.preferredFont(forTextStyle: .body).withSize(fontSize)
        font = UIFontMetrics(forTextStyle: .body).scaledFont(for: font)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        return NSAttributedString(string: string, attributes: [.paragraphStyle:paragraphStyle, .font:font])
    }
    
    private var cornerString : NSAttributedString{
        return centerAttributedString(rankString + "\n" + suit, fontSize: cornerFontSize)
    }
    

    private lazy var upperLeftCornerLabel = createCornerLabel()
    private lazy var lowerRightCornerLabel = createCornerLabel()
    
    private func createCornerLabel() -> UILabel{
        let label = UILabel()
        label.numberOfLines = 0
        addSubview(label)
        return label
    }
    
    private func configureCornerLable(_ label: UILabel){
        label.attributedText = cornerString
        label.frame.size = CGSize.zero
        label.sizeToFit()
        label.isHidden = !isFaceUp
    }
    
    // setdisplay
    override func draw(_ rect: CGRect) {
        // 设置背景
        let roundRect = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        roundRect.addClip()
        UIColor.white.setFill()
        roundRect.fill()
    }
    // setlayout
    override func layoutSubviews() {
        super.layoutSubviews()
        configureCornerLable(upperLeftCornerLabel)
        upperLeftCornerLabel.frame.origin = bounds.origin.offsetBy(dx: cornerOffset, dy: cornerOffset)
        
        configureCornerLable(lowerRightCornerLabel)
        lowerRightCornerLabel.transform = CGAffineTransform.identity.rotated(by: CGFloat.pi)
        lowerRightCornerLabel.frame.origin = CGPoint(x: bounds.maxX,y: bounds.maxY).offsetBy(dx: -cornerOffset, dy: -cornerOffset).offsetBy(dx: -lowerRightCornerLabel.frame.size.width, dy: -lowerRightCornerLabel.frame.size.height)
        
    }
    
}

extension PlayingCardView{
    private struct SizeRatio {
        static let cornerFontSizeToBoundsHeight : CGFloat = 0.085
        static let cornerRadiusToBoundsHeight : CGFloat = 0.06
        static let cornerOffSetToCornerRadius : CGFloat = 0.33
        static let faceCardImageSizeToBoundsSize : CGFloat = 0.75
    }
    
    private var cornerRadius : CGFloat {
        return bounds.size.height * SizeRatio.cornerRadiusToBoundsHeight
    }
    
    private var cornerOffset : CGFloat {
        return cornerRadius * SizeRatio.cornerOffSetToCornerRadius
    }
    
    private var cornerFontSize : CGFloat{
        return bounds.size.height * SizeRatio.cornerFontSizeToBoundsHeight
    }
    
    private var rankString : String{
        switch rank {
        case 1:
            return "A"
        case 2...10:
            return String(rank)
        case 11: return "J"
        case 12: return "Q"
        case 13: return "K"
        default:
            return "?"
        }
    }
}

extension CGRect {
    var leftHalf :CGRect{
        return CGRect(x:minX,y:minY,width:width/2, height:height)
    }
    var rightHalf :CGRect{
        return CGRect(x:midX,y:minY,width:width/2, height:height)
    }
    
    func inset(by size:CGSize) ->CGRect{
        return insetBy(dx: size.width, dy: size.height)
    }
    
    func zoom(by scale:CGFloat)->CGRect{
        let newWidth = width * scale
        let newHeight = height * scale
        return insetBy(dx: (width-newWidth)/2, dy: (height-newHeight)/2)
    }

}


extension CGPoint{
    func offsetBy(dx: CGFloat, dy: CGFloat) ->CGPoint{
        return CGPoint(x: x+dx, y:y+dy)
    }
}
