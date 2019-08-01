//
//  Calculator.swift
//  CountOnMe
//
//  Created by co5ta on 18/07/2019.
//  Copyright © 2019 Vincent Saluzzo. All rights reserved.
//

import Foundation

class Calculator {
    /// The expression which indicates the operation
    var expression = "" {
        didSet {
            if expression.isEmpty {
                expression = defaultValue
            }
            refresh()
        }
    }
    
    /// Default value of the expression
    var defaultValue = "0"
    
    /// Array of elements that are in the expression
    var elements: [String] {
        return expression.split(separator: " ").map { "\($0)" }
    }
    
    var expressionHaveEnoughElement: Bool {
        return elements.count >= 3
    }
    
    var lastElementIsOperator: Bool {
        if let lastElement = elements.last, allOperators.contains(lastElement) {
            return true
        } else {
            return false
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
    func add(number: String) {
        if expressionHaveResult || expression == defaultValue {
            expression = number
        } else {
            expression.append(number)
        }
    }
    
    func add(operand: String) {
        guard !lastElementIsOperator && !expression.isEmpty else { return }
        if expressionHaveResult, let result = elements.last {
            expression = "\(result)"
        }
        expression.append(" \(operand) ")
    }
    
    func addResult() {
        guard !lastElementIsOperator, !expressionHaveResult else { return }
        guard expressionHaveEnoughElement else { return }
        expression.append(" = \(getResult())")
    }
    
    /// Give the result of the expression
    private func getResult() -> String {
        var operationsToReduce = elements
        while operationsToReduce.count > 1 {
            let operandIndex = getOperandIndex(from: operationsToReduce)
            guard let operation = getOperation(from: operationsToReduce, at: operandIndex) else { return "Error" }
            guard let result = calculate(left: operation.left, symbol: operation.operand, right: operation.right) else { return "Error"}
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
    private func calculate(left: Float, symbol: String, right: Float) -> String? {
        guard let operand = Operator(rawValue: symbol) else { fatalError("Unknown operator !") }
        let result: Float
        
        switch operand {
        case .addition: result = left + right
        case .substration: result = left - right
        case .multiplication: result = left * right
        case .division: result = left / right
        }
        
        return format(number: result)
    }
    
    /// Format the display of the result as a decimal or a integer
    private func format(number: Float) -> String? {
        if number.isInfinite {
            return nil
        } else if floorf(number) == number {
            return "\(Int(number))"
        } else {
            return "\(number)"
        }
    }
    
    func cancel(fully: Bool = false) {
        if expressionHaveResult || fully == true {
            expression.removeAll()
        } else {
            removeLastEntry()
        }
    }
    
    /// Remove the last character of the expression
    private func removeLastEntry() {
        var character: Character = " "
        while character == " " && !expression.isEmpty {
            character = expression.removeLast()
        }
    }
    
    func refresh() {
        let name = Notification.Name("ExpressionUpdated")
        let notification = Notification(name: name)
        NotificationCenter.default.post(notification)
    }
}
