//
//  Calculator.swift
//  CountOnMe
//
//  Created by co5ta on 18/07/2019.
//  Copyright © 2019 Vincent Saluzzo. All rights reserved.
//

import Foundation

struct Calculator {
    /// Expression to calculate
    var expression = "" 
    
    /// Array of elements that are in the expression
    var elements: [String] {
        return expression.split(separator: " ").map { "\($0)" }
    }
    
    // Error check computed variables
    var expressionIsCorrect: Bool {
        return elements.last != "+" && elements.last != "-"
    }
    
    var expressionHaveEnoughElement: Bool {
        return elements.count >= 3
    }
    
    var canAddOperator: Bool {
        return elements.last != "+" && elements.last != "-"
    }
    
    var expressionHaveResult: Bool {
        return expression.firstIndex(of: "=") != nil
    }
}

extension Calculator {
    /// Give the result of the expression
    func getResult() -> String {
        var operationsToReduce = elements
        while operationsToReduce.count > 1 {
            let operandIndex = getOperandIndex(from: operationsToReduce)
            let operation = getOperation(from: operationsToReduce, at: operandIndex)
            let result = calculate(left: operation.left, operand: operation.operand, right: operation.right)
            
            operationsToReduce[operandIndex] = result
            operationsToReduce.remove(at: operandIndex + 1)
            operationsToReduce.remove(at: operandIndex - 1)
        }
        return operationsToReduce[0]
    }
    
    /// Pick the index of an operator
    private func getOperandIndex(from elements: [String]) -> Int {
        if let index = elements.firstIndex(where: { $0 == "x" || $0 == "÷"}) {
            return index
        } else {
            return 1
        }
    }
    
    /// Get a part of the expression to make a simple calculation
    private func getOperation(from elements: [String], at index: Int) -> (left: Float, operand: String, right: Float) {
        let operand = elements[index]
        guard let left = Float(elements[index - 1]), let right = Float(elements[index + 1]) else {
            fatalError("A number could not be recognized")
        }
        return (left, operand, right)
    }
    
    /// Calculate an operation between to number
    private func calculate(left: Float, operand: String, right: Float) -> String {
        let result: Float
        switch operand {
        case "+": result = left + right
        case "-": result = left - right
        case "x": result = left * right
        case "÷": result = left / right
        default: fatalError("Unknown operator !")
        }
        
        return format(number: result)
    }
    
    private func format(number: Float) -> String {
        if floorf(number) == number {
            return "\(Int(number))"
        } else {
            return "\(number)"
        }
    }
}
