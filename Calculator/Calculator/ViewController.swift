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

    var displayValue :Double{
        get{
            return Double(display.text!)!
        }
        set{
            display.text = String(newValue)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    // ctrl+i 格式化代码
    @IBAction func performOperation(_ sender: UIButton) {
        userIsInTheMiddleOfTyping = false
        if let mathematicalSymbol = sender.currentTitle{
            switch mathematicalSymbol{
            case "π":
                displayValue = Double.pi
            case "√":
                displayValue = sqrt(displayValue)
            default:
                break
            }
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

