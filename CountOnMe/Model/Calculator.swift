//
//  Calculator.swift
//  CountOnMe
//
//  Created by co5ta on 18/07/2019.
//  Copyright © 2019 Vincent Saluzzo. All rights reserved.
//

import Foundation

class Calculator {
    // MARK: Properties
    
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
    
    /// Array of elements which are in the expression
    var elements: [String] {
        return expression.split(separator: " ").map { "\($0)" }
    }
    
    /// Return true if the expression have enough elements to do a calculation
    var expressionHaveEnoughElement: Bool {
        return elements.count >= 3
    }
    
    /// Return true if the last element of the expression is an operand
    var lastElementIsOperand: Bool {
        if let lastElement = elements.last, allOperands.contains(lastElement) {
            return true
        } else {
            return false
        }
    }
    
    /// Return true if the expression contains the result of the operation
    var expressionHaveResult: Bool {
        return elements.contains("=")
    }
    
    /// Array of all operands
    var allOperands: [String] {
        return Operand.allCases.map { $0.rawValue }
    }
}

// MARK: - Operands

extension Calculator {
    /// The Operands available in the calculator
    enum Operand: String, CaseIterable {
        /// Calculation operand
        case addition = "+"
        case substration = "-"
        case multiplication = "x"
        case division = "÷"
    }
}

// MARK: - Expression edition

extension Calculator {
    /// Add a number to the expression
    func add(number: String) {
        if expressionHaveResult || expression == defaultValue {
            expression = number
        } else {
            expression.append(number)
        }
    }
    
    /// Add an operand to the expression
    func add(operand: String) {
        guard !lastElementIsOperand && !expression.isEmpty else { return }
        if expressionHaveResult, let result = elements.last {
            expression = "\(result)"
        }
        expression.append(" \(operand) ")
    }
    
    /// Add the result of the operation to the expression
    func addResult() {
        guard expressionHaveEnoughElement, !lastElementIsOperand, !expressionHaveResult else { return }
        expression.append(" = \(getResult())")
    }
    
    /// Remove some entry from the expression
    func cancel(fully: Bool = false) {
        if expressionHaveResult || fully == true {
            expression.removeAll()
        } else if !expression.isEmpty {
            removeLastEntry()
        }
    }
    
    /// Remove the last character of the expression
    private func removeLastEntry() {
        var character: Character
        repeat {
            character = expression.removeLast()
        } while character == " "
    }
    
    /// Notification to tell that the expression has changed
    func refresh() {
        let name = Notification.Name("ExpressionUpdated")
        let notification = Notification(name: name)
        NotificationCenter.default.post(notification)
    }
}

// MARK: - Expression calculation

extension Calculator {
    /// Give the result of the expression
    private func getResult() -> String {
        var elementsToReduce = elements
        while elementsToReduce.count > 1 {
            let operandIndex = getOperandIndex(from: elementsToReduce)
            guard let operation = getOperation(from: elementsToReduce, at: operandIndex) else { return "Error" }
            guard let result = calculate(left: operation.left, symbol: operation.operand, right: operation.right) else { return "Infinity"}
            elementsToReduce = reduce(elementsToReduce, with: result, at: operandIndex)
        }
        return elementsToReduce[0]
    }
    
    /// Pick the index of an operand
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
        guard let operand = Operand(rawValue: symbol) else { fatalError("Unknown operand !") }
        let result: Float
        
        switch operand {
        case .addition: result = left + right
        case .substration: result = left - right
        case .multiplication: result = left * right
        case .division: result = left / right
        }
        
        return format(number: result)
    }
    
    /// Format the display of the result as a decimal or an integer
    private func format(number: Float) -> String? {
        if number.isInfinite {
            return nil
        } else if floorf(number) == number {
            return "\(Int(number))"
        } else {
            return "\(number)"
        }
    }
    
    /// Reduce the array of elements with a result
    private func reduce(_ elements: [String], with result:String, at index: Int) -> [String] {
        var elementsToReduce = elements
        elementsToReduce[index] = result
        elementsToReduce.remove(at: index + 1)
        elementsToReduce.remove(at: index - 1)
        return elementsToReduce
    }
}
