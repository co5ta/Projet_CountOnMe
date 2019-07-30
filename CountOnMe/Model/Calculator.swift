//
//  Calculator.swift
//  CountOnMe
//
//  Created by co5ta on 18/07/2019.
//  Copyright © 2019 Vincent Saluzzo. All rights reserved.
//

import Foundation

struct Calculator {
    /// Array of elements that are in the expression
    var elements = [String]()
    
    var expressionHaveEnoughElement: Bool {
        return elements.count >= 3
    }
    
    var lastElementIsNotOperator: Bool {
        if let lastElement = elements.last, allOperators.contains(lastElement) {
            return false
        } else {
            return true
        }
    }
    
    var expressionHaveResult: Bool {
        return elements.firstIndex(of: "=") != nil
    }
    
    /// Array of all operators
    var allOperators: [String] {
        return Operator.allCases.map { $0.rawValue }
    }
}

// MARK: Operators

extension Calculator {
    /// The Operators available in the calculator
    enum Operator: String, CaseIterable {
        /// Calculation operator
        case addition = "+"
        case substration = "-"
        case multiplication = "x"
        case division = "÷"
    }
}

extension Calculator {
    /// Give the result of the expression
    func getResult() -> String {
        var operationsToReduce = elements
        while operationsToReduce.count > 1 {
            let operandIndex = getOperandIndex(from: operationsToReduce)
            guard let operation = getOperation(from: operationsToReduce, at: operandIndex) else { return "Error" }
            guard let result = calculate(left: operation.left, operand: operation.operand, right: operation.right) else { return "Error"}
            
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
    private func getOperation(from elements: [String], at index: Int) -> (left: Float, operand: String, right: Float)? {
        let operand = elements[index]
        guard let left = Float(elements[index - 1]), let right = Float(elements[index + 1]) else { return nil }
        return (left, operand, right)
    }
    
    /// Calculate an operation between to number
    private func calculate(left: Float, operand: String, right: Float) -> String? {
        let result: Float
        switch operand {
        case "+": result = left + right
        case "-": result = left - right
        case "x": result = left * right
        case "÷": result = left / right
        default: fatalError("Unknown operator !")
        }
        
        if result.isInfinite {
            return nil
        } else {
            return format(number: result)
        }
    }
    
    /// Format the display of the result as a decimal or a integer
    private func format(number: Float) -> String {
        if floorf(number) == number {
            return "\(Int(number))"
        } else {
            return "\(number)"
        }
    }
}
