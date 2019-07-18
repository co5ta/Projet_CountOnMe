//
//  ViewController.swift
//  SimpleCalc
//
//  Created by Vincent Saluzzo on 29/03/2019.
//  Copyright © 2019 Vincent Saluzzo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var textView: UITextView!
    @IBOutlet var numberButtons: [UIButton]!
    
    var calculator = Calculator()
    
    var expression = "" {
        didSet {
            calculator.expression = expression
            textView.text = expression
        }
    }
    
    // View actions
    @IBAction func tappedNumberButton(_ sender: UIButton) {
        guard let numberText = sender.title(for: .normal) else { return }
        
        if calculator.expressionHaveResult {
            expression = ""
        }
        
        expression.append(numberText)
    }

    @IBAction func tappedOperatorButton(_ sender: UIButton) {
        guard calculator.canAddOperator else {
            return presentAlert(title: "Zero!", message: "An operator is already put")
        }
        
        if let symbol = sender.currentTitle {
            expression.append(" \(symbol) ")
        }
    }
    
    @IBAction func tappedEqualButton(_ sender: UIButton) {
        guard calculator.expressionIsCorrect else {
            return presentAlert(title: "Zero!", message: "Enter a correct expression")
        }
        
        guard calculator.expressionHaveEnoughElement else {
            return presentAlert(title: "Zero!", message: "Start a new calculation")
        }
        
        // Create local copy of operations
        var operationsToReduce = calculator.elements
        
        // Iterate over operations while an operand still here
        while operationsToReduce.count > 1 {
            let left = Int(operationsToReduce[0])!
            let operand = operationsToReduce[1]
            let right = Int(operationsToReduce[2])!
            
            let result: Int
            switch operand {
            case "+": result = left + right
            case "-": result = left - right
            case "x": result = left * right
            case "÷": result = left / right
            default: fatalError("Unknown operator !")
            }
            
            operationsToReduce = Array(operationsToReduce.dropFirst(3))
            operationsToReduce.insert("\(result)", at: 0)
        }
        
        expression.append(" = \(operationsToReduce.first!)")
    }

    private func presentAlert(title: String, message: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alertVC, animated: true, completion: nil)
    }
}

