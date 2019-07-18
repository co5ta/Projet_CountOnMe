//
//  Calculator.swift
//  CountOnMe
//
//  Created by co5ta on 18/07/2019.
//  Copyright © 2019 Vincent Saluzzo. All rights reserved.
//

import Foundation

struct Calculator {
    var expression = "" 
    
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
