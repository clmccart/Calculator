//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Eric Chown on 9/7/16.
//  Copyright © 2016 edu.bowdoin.cs2505.chown. All rights reserved.
//

import Foundation

class CalculatorBrain {
    enum Operation {
        case Constant(Double)
        case UnaryOperation((Double) -> Double)
        case BinaryOperation((Double, Double) -> Double)
        case Equals
    }
    
    struct PendingBinaryOperationInfo {
        var binaryFunction: (Double, Double) -> Double
        var firstOperand: Double
    }
    
    private var pending: PendingBinaryOperationInfo?
    
    private var internalProgram = [AnyObject]()
    
    private var descriptionString = ""
    private var endDescription = ""
    
    var isPartialResult = false
    
    var description: String {
        get {
            if descriptionString == "" {
                return " "
            } else {
                return descriptionString + endDescription
            }
        }
    }
    
    
    var operations = [
        "π": Operation.Constant(M_PI),
        "℮": Operation.Constant(M_E),
        "cos": Operation.UnaryOperation(cos),
        "×": Operation.BinaryOperation( { $0 * $1 } ),
        "÷": Operation.BinaryOperation( {$0 / $1} ),
        "−": Operation.BinaryOperation( {$0 - $1}),
        "+": Operation.BinaryOperation( {$0 + $1}),
        "=": Operation.Equals,
        "√": Operation.UnaryOperation(sqrt)
    ]
    
    typealias PropertyList = AnyObject
    var program: PropertyList {
        get {
            return internalProgram
        }
        set {
            clear()
            if let arrayOfOps = newValue as? [PropertyList] {
                for op in arrayOfOps {
                    if let operand = op as? Double {
                        setOperand(operand)
                    } else if let operation = op as? String {
                        performOperation(operation)
                    }
                }
            }
        }
        
    }
    
    func clear() {
        accumulator = 0.0
        pending = nil
        internalProgram.removeAll()
        descriptionString = ""
        endDescription = ""
    }
    
    
    func setOperand(operand: Double) {
        accumulator = operand
        internalProgram.append(operand)
        if !isPartialResult {
            descriptionString = ""
        }
        endDescription = String(operand)
    }
    
    func performOperation(symbol: String) {
        if let constant = operations[symbol] {
            internalProgram.append(symbol)
            switch constant {
            case .Constant(let value):
                accumulator = value
                if !isPartialResult {
                    descriptionString = ""
                }
                endDescription = symbol
            case .UnaryOperation(let function):
                accumulator = function(accumulator)
                if isPartialResult {
                    endDescription = symbol + "(" + endDescription + ")"
                } else {
                    descriptionString = symbol + "(" + descriptionString + ")"
                }
            case .BinaryOperation(let function):
                executePendingBinaryOperation()
                pending = PendingBinaryOperationInfo(binaryFunction: function, firstOperand: accumulator)
                isPartialResult = true
                descriptionString = descriptionString + endDescription + " " + symbol
                endDescription = ""
            case .Equals:
                if endDescription == "" {
                    endDescription = String(accumulator)
                }
                executePendingBinaryOperation()
                isPartialResult = false
                descriptionString = descriptionString + " " + endDescription
                endDescription = ""
            }
        }
    }
    
    private func executePendingBinaryOperation() {
        if pending != nil {
            accumulator = pending!.binaryFunction(pending!.firstOperand, accumulator)
            pending = nil
        }
    }
    
    var result: Double {
        get {
            return accumulator
        }
    }
    
    private var accumulator = 0.0
    
}
