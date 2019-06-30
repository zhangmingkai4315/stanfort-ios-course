//
//  ViewController.swift
//  Calculator
//
//  Created by 明凯张 on 2019/5/1.
//  Copyright © 2019 明凯张. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var display: UILabel!
    var userIsInTheMiddleOfTyping = false
    
    
    
    
    
    
    private var brain = CalculatorBrain()
    
    var displayValue :Double{
        get{
            return Double(display.text!)!
        }
        set{
            display.text = String(newValue)
        }
    }
    
    // ctrl+i 格式化代码
    @IBAction func performOperation(_ sender: UIButton) {
        if userIsInTheMiddleOfTyping{
            brain.setOperand(displayValue)
            userIsInTheMiddleOfTyping = false
        }
        if let mathematicalSymbol = sender.currentTitle{
            brain.performOperation(mathematicalSymbol)
        }
        if let result = brain.result {
            displayValue = result
        }
    }
    
    @IBAction func touchDigit(_ sender: UIButton) {
        let digit : String = sender.currentTitle!
        if userIsInTheMiddleOfTyping == true{
            let textCurrentInDisplay = display!.text!
            display!.text = textCurrentInDisplay + digit
        }else{
            display!.text = digit
            userIsInTheMiddleOfTyping = true
        }
        
    }
    
}

