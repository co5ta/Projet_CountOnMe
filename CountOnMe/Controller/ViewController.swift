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
        
        let result = calculator.getResult()
        expression.append(" = \(result)")
    }

    private func presentAlert(title: String, message: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alertVC, animated: true, completion: nil)
    }
}

