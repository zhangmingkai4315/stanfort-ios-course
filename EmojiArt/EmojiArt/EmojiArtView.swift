//
//  EmojiArtView.swift
//  EmojiArt
//
//  Created by mingkai on 2019/6/23.
//  Copyright © 2019年 mingkai. All rights reserved.
//

import UIKit

class EmojiArtView: UIView {

    var backgroundImage : UIImage?{
        didSet {
            setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect) {
        backgroundImage?.draw(in: bounds)
    }
}
