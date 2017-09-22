//
//  CalculatorBrain.swift
//  test
//
//  Created by Miquel Àngel Rigo Vidal on 18/09/2017.
//  Copyright © 2017 Miquel Àngel Rigo Vidal. All rights reserved.
//

import Foundation


struct CalculatorBrain {
    
    private var accumulator: Double?
    
    private var pendingUnaryOperation = false
    private var pendingConstant =  false
    
    private var description = ""
    
    private var resultIsPending: Bool {
        get {
            return pendingBinaryOperation != nil
        }
    }
    
    private enum Operation {
        case consant(Double)
        case unaryOperation((Double) -> Double)
        case binaryOperation(((Double), (Double)) -> Double)
        case equals
        case nullaryOperator
    }
    
    private var operations: Dictionary<String,Operation> =
        [
            "π"     : Operation.consant(Double.pi), // Double.pi
            "e"     : Operation.consant(M_E),   //M_E,
            "√"     : Operation.unaryOperation(sqrt),
            "cos"   : Operation.unaryOperation(cos),
            "sin"   : Operation.unaryOperation(sin),
            "x²"    : Operation.unaryOperation({$0 * $0}),
            "x³"    : Operation.unaryOperation({$0 * $0 * $0}),
            "x⁻¹"   : Operation.unaryOperation({1 / $0}),
            "×"     : Operation.binaryOperation({$0 * $1}),
            "÷"     : Operation.binaryOperation({$0 / $1}),
            "+"     : Operation.binaryOperation({$0 + $1}),
            "-"     : Operation.binaryOperation({$0 - $1}),
            "="     : Operation.equals,
            "C"     : Operation.nullaryOperator
    ]
    
    mutating func performOperation(_ symbol: String){
        if let operation = operations[symbol] {
            switch operation {
            case .consant(let value):
                accumulator = value
                pendingConstant = true
                if resultIsPending {
                    description += symbol
                }
            case .unaryOperation(let function):
                if accumulator != nil {
                    if resultIsPending {
                        description += symbol + "(" + String(accumulator!) + ")"
                    } else {
                        description = symbol + "(" + description + ")"
                    }
                    accumulator = function(accumulator!)
                    pendingUnaryOperation = true
                }
                
            case .binaryOperation(let function):
                if accumulator != nil {
                    if resultIsPending {
                        performPendingBinaryOperation()
                    }
                    pendingBinaryOperation = PendingBinaryOperation(function: function, firstOperand: accumulator!)
                    description += symbol
                    accumulator = nil
                    pendingUnaryOperation = false
                    pendingConstant = false
                }
            case .nullaryOperator:
                pendingUnaryOperation = false
                pendingConstant = false
                description = ""
                accumulator = 0
                pendingBinaryOperation = nil
                
            case .equals:
                performPendingBinaryOperation()
            }
        }
        
    }
    
    private mutating func performPendingBinaryOperation() {
        if pendingBinaryOperation != nil && accumulator != nil {
            if !pendingUnaryOperation && !pendingConstant {description += String(accumulator!)}
            accumulator = pendingBinaryOperation!.perform(with: accumulator!)
            pendingBinaryOperation = nil
        }
    }
    
    private var pendingBinaryOperation: PendingBinaryOperation?
    
    private struct PendingBinaryOperation {
        let function: (Double, Double) -> Double
        let firstOperand: Double
        func perform(with secondOperand: Double) -> Double {
            return function(firstOperand, secondOperand)
        }
    }
    
    mutating func setOperand(_ operand: Double){
        accumulator = operand
        if !resultIsPending {
            description = String(operand)
        }
    }
    
    var sequence: String {
        mutating get {
            let sequence = description
            if !resultIsPending && sequence != "" {
                return sequence + "="
            } else {
                return sequence + "..."
                
            }
        }
    }
    
    var result: Double? {
        get {
            return accumulator
        }
    }
}
