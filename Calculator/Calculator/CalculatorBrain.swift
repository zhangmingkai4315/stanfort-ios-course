//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by 明凯张 on 2019/5/1.
//  Copyright © 2019 明凯张. All rights reserved.
//

import Foundation


struct CalculatorBrain {
    
    private var accumulator: Double?
    
    private enum Operation {
        case constant(Double)
        case unaryOperation((Double) -> Double)
        case binaryOperation((Double,Double) -> Double)
        case equals
    }
    
    private var operations: Dictionary<String, Operation> = [
        "π":Operation.constant(Double.pi),
        "e": Operation.constant(M_E),
        "√": Operation.unaryOperation(sqrt),
        "cos": Operation.unaryOperation(cos),
        "±": Operation.unaryOperation({-$0}),
        "×":Operation.binaryOperation({$0 * $1}),
        "+":Operation.binaryOperation({$0 + $1}),
        "−":Operation.binaryOperation({$0 - $1}),
        "÷":Operation.binaryOperation({$0 / $1}),
        "=":Operation.equals,
    ]
    
    private struct PendingBinaryOperation{
        let function: (Double, Double) -> Double
        let firstOperand : Double
        
        func perform(with secondOperand: Double) -> Double{
            return function(firstOperand, secondOperand)
        }
    }
    
    private var pendingBinaryOperation : PendingBinaryOperation?
    mutating private func performPendingBinaryOperation(){
        if pendingBinaryOperation != nil && accumulator != nil{
            accumulator = pendingBinaryOperation!.perform(with: accumulator!)
        }
    }
    mutating func performOperation(_ symbol: String){
        if let operation = operations[symbol]{
            switch operation{
            case .constant(let value):
                accumulator = value
            case .unaryOperation(let unaryFunc):
                if accumulator != nil{
                    accumulator = unaryFunc(accumulator!)
                }
            case .binaryOperation(let binaryFunc):
                if accumulator != nil{
                    pendingBinaryOperation = PendingBinaryOperation(function: binaryFunc, firstOperand: accumulator!)
                    accumulator = nil
                }
                break;
            case .equals:
                performPendingBinaryOperation()
            }
        }
    }
    
    mutating func setOperand(_ operand: Double){
        accumulator = operand
    }
    
    var result: Double?{
        get{
            return accumulator
        }
        
    }
}
