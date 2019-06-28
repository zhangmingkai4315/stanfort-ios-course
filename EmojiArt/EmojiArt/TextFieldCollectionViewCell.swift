//
//  TextFieldCollectionViewCell.swift
//  EmojiArt
//
//  Created by mingkai on 2019/6/28.
//  Copyright © 2019年 mingkai. All rights reserved.	
//

import UIKit

class TextFieldCollectionViewCell: UICollectionViewCell,UITextFieldDelegate {
    
    @IBOutlet weak var textField: UITextField!{
        didSet{
            textField.delegate = self
        }
    }
    
    var resignationHandler :(()->Void)?
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
            resignationHandler?()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
}
