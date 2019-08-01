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
    
    // MARK: Life Cycle
    
    /// Initialisation of the view
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // long press gesture
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPressedCancelButton))
        cancelButton.addGestureRecognizer(longPress)
        
        // notification listening
        let name = Notification.Name("ExpressionUpdated")
        NotificationCenter.default.addObserver(self, selector: #selector(updateTextView), name: name, object: nil)
    }
}

// MARK: - Methods

extension ViewController {
    /// Action when a number is tapped
    @IBAction func tappedNumberButton(_ sender: UIButton) {
        guard let number = sender.title(for: .normal) else { return }
        calculator.add(number: number)
    }

    /// Action when an operand is tapped
    @IBAction func tappedOperandButton(_ sender: UIButton) {
        guard let symbol = sender.currentTitle else { return }
        calculator.add(operand: symbol)
    }
    
    /// Action when the button equal is tapped
    @IBAction func tappedEqualButton(_ sender: UIButton) {
        calculator.addResult()
    }
    
    /// Action when an the cancel button is tapped
    @IBAction func tappedCancelButton(_ sender: UIButton) {
        calculator.cancel()
    }
    
    /// Action after the cancel button is long pressed
    @objc func longPressedCancelButton() {
        calculator.cancel(fully: true)
    }
    
    /// Update the textView
    @objc func updateTextView() {
        textView.text = calculator.expression
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

