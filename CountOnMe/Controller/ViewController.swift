//
//  ViewController.swift
//  SimpleCalc
//
//  Created by Vincent Saluzzo on 29/03/2019.
//  Copyright © 2019 Vincent Saluzzo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    // MARK: Outlets
    
    /// TextView which displays the expression
    @IBOutlet weak var textView: UITextView!
    
    /// Array of buttons
    @IBOutlet var numberButtons: [UIButton]!
    
    /// Cancel button
    @IBOutlet weak var cancelButton: UIButton!
    
    // MARK: Properties
    
    /// The object which calculate the operations
    var calculator = Calculator()
    
    /// Default value of the expression
    var defaultValue = "0"
    
    /// The expression which indicates the operation
    var expression = "" {
        didSet {
            if expression.isEmpty {
                expression = defaultValue
            }
            calculator.elements = expression.split(separator: " ").map { "\($0)" }
            textView.text = expression
        }
    }
    
    // MARK: Life Cycle
    
    /// Initialisation of the view
    override func viewDidLoad() {
        super.viewDidLoad()
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPressedCancelButton))
        cancelButton.addGestureRecognizer(longPress)
    }
}

// MARK: - Methods

extension ViewController {
    /// Action when a number is tapped
    @IBAction func tappedNumberButton(_ sender: UIButton) {
        guard let numberText = sender.title(for: .normal) else { return }
        
        if calculator.expressionHaveResult || expression == defaultValue {
            expression = numberText
        } else {
            expression.append(numberText)
        }
    }

    /// Action when an operator is tapped
    @IBAction func tappedOperatorButton(_ sender: UIButton) {
        guard calculator.lastElementIsNotOperator && !expression.isEmpty else {
            return presentAlert(title: "Zero!", message: "An operator is already put")
        }
        
        if calculator.expressionHaveResult, let result = calculator.elements.last{
            expression = "\(result)"
        }
        
        if let symbol = sender.currentTitle {
            expression.append(" \(symbol) ")
        }
    }
    
    /// Action when the button equal is tapped
    @IBAction func tappedEqualButton(_ sender: UIButton) {
        guard calculator.lastElementIsNotOperator, !calculator.expressionHaveResult else {
            return presentAlert(title: "Zero!", message: "Enter a correct expression")
        }
        
        guard calculator.expressionHaveEnoughElement else {
            return presentAlert(title: "Zero!", message: "Start a new calculation")
        }
        
        let result = calculator.getResult()
        expression.append(" = \(result)")
    }
    
    /// Action when an the cancel button is tapped
    @IBAction func tappedCancelButton(_ sender: UIButton) {
        if calculator.expressionHaveResult {
            expression.removeAll()
        } else {
            removeLastCharacter()
        }
    }
    
    /// Remove the last character of the expression
    private func removeLastCharacter() {
        var character: Character = " "
        while character == " " && !expression.isEmpty {
            character = expression.removeLast()
        }
    }
    
    /// Action after the cancel button is long pressed
    @objc func longPressedCancelButton() {
        expression.removeAll()
    }
    
    /**
    Present an alert
     - parameter title: Title of the alert
     - parameter message: Message in the alert
    */
    private func presentAlert(title: String, message: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alertVC, animated: true, completion: nil)
    }
}

