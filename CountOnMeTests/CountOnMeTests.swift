//
//  SimpleCalcTests.swift
//  SimpleCalcTests
//
//  Created by Vincent Saluzzo on 29/03/2019.
//  Copyright © 2019 Vincent Saluzzo. All rights reserved.
//

import XCTest
@testable import CountOnMe

class CountOnMeTests: XCTestCase {

    var calculator: Calculator!
    
    override func setUp() {
        calculator = Calculator()
    }

    func testGivenFirstNumberIsFive_WhenAdditionningWithNumberHeight_ThenTotalIsThirteen() {
        calculator.add(number: "5")
        calculator.add(operand: "+")
        calculator.add(number: "8")
        calculator.addResult()
        XCTAssertEqual(calculator.expression, "5 + 8 = 13")
    }
    
    func testGivenFirstNumberIsSix_WhenSubstractingWithNumberFour_ThenTotalIsTwo() {
        calculator.add(number: "6")
        calculator.add(operand: "-")
        calculator.add(number: "4")
        calculator.addResult()
        XCTAssertEqual(calculator.expression, "6 - 4 = 2")
    }
    
    
    func testGivenFirstNumberIsFive_WhenMultiplicatingBySevenAndTwo_ThenTotalIsSeventy() {
        calculator.add(number: "7")
        calculator.add(operand: "x")
        calculator.add(number: "2")
        calculator.addResult()
        XCTAssertEqual(calculator.expression, "7 x 2 = 14")
    }
    
    func testGivenExpressionIsTenDividedByFive_WhenCalculatingTotal_ThenResultIsTwo() {
        calculator.add(number: "10")
        calculator.add(operand: "÷")
        calculator.add(number: "5")
        calculator.addResult()
        XCTAssertEqual(calculator.expression, "10 ÷ 5 = 2")
    }
    
    func testGivenExpressionIsFiveDividedByTwo_WhenCalculatingTotal_ThenResultIsTwoPointFive() {
        calculator.add(number: "5")
        calculator.add(operand: "÷")
        calculator.add(number: "2")
        calculator.addResult()
        XCTAssertEqual(calculator.expression, "5 ÷ 2 = 2.5")
    }
    
    func testGivenExpressionContainsMultipleOperators_WhenGettingTotal_OrderOfOperationsIsRespected() {
        calculator.add(number: "5")
        calculator.add(operand: "+")
        calculator.add(number: "8")
        calculator.add(operand: "-")
        calculator.add(number: "2")
        calculator.add(operand: "x")
        calculator.add(number: "6")
        calculator.add(operand: "+")
        calculator.add(number: "12")
        calculator.add(operand: "÷")
        calculator.add(number: "3")
        calculator.addResult()
        XCTAssertEqual(calculator.expression, "5 + 8 - 2 x 6 + 12 ÷ 3 = 5")
    }
    
    func testGivenExpressionIsFiveDividedByZero_WhenCalculatingTotal_ThenResultIsError() {
        calculator.add(number: "5")
        calculator.add(operand: "÷")
        calculator.add(number: "0")
        calculator.addResult()
        XCTAssertEqual(calculator.expression, "5 ÷ 0 = Error")
    }
    
    func testGivenExpressionIsFiveDividedByTwo_WhenCancelFully_ThenExpressionIsZero() {
        calculator.add(number: "5")
        calculator.add(operand: "÷")
        calculator.add(number: "2")
        calculator.cancel(fully: true)
        XCTAssertEqual(calculator.expression, "0")
    }
    
    func testGivenExpressionIsFiveDividedByTwo_WhenCancelTwoTimes_ThenExpressionIsFive() {
        calculator.add(number: "5")
        calculator.add(operand: "÷")
        calculator.add(number: "2")
        calculator.cancel()
        calculator.cancel()
        XCTAssertEqual(calculator.expression, "5")
    }
    
    func testGivenExpressionIsFivePlusPlusNothing_WhenCalculatingTotal_ThenExpressionHasNoResult() {
        calculator.add(number: "5")
        calculator.add(operand: "+")
        calculator.add(operand: "+")
        calculator.addResult()
        XCTAssertEqual(calculator.expression, "5 + ")
    }
    
    func testGivenExpressionIsDefaultValue_WhenAddingOperatorFirst_ThenExpressionDoesNotBeginByAnOperand() {
        calculator.add(operand: "+")
        calculator.add(number: "5")
        calculator.addResult()
        XCTAssertEqual(calculator.expression, "0 + 5 = 5")
    }
    
    func testGivenExpressionIsFivePlusZeroFive_WhenCalculatingTotal_ThenResultIsTen() {
        calculator.add(number: "0")
        calculator.add(number: "5")
        calculator.add(operand: "+")
        calculator.add(number: "0")
        calculator.add(number: "5")
        calculator.addResult()
        XCTAssertEqual(calculator.expression, "5 + 5 = 10")
    }
    
    func testGivenExpressionIsFivePlusSeven_WhenDividingTotalByThree_ThenResultIsFour() {
        calculator.add(number: "5")
        calculator.add(operand: "+")
        calculator.add(number: "7")
        calculator.addResult()
        calculator.add(operand: "÷")
        calculator.add(number: "3")
        calculator.addResult()
        XCTAssertEqual(calculator.expression, "12 ÷ 3 = 4")
    }
    
    func testGivenExpressionIsZeroDivideByZero_WhenCalculatingTotal_ThenResultIsError() {
        calculator.add(number: "0")
        calculator.add(operand: "÷")
        calculator.add(number: "0")
        calculator.addResult()
        XCTAssertEqual(calculator.expression, "0 ÷ 0 = Error")
    }
    
    func testGivenExpressionIsTenModuloThree_WhenCalculatingTotal_ThenResultIsBadOperation() {
        calculator.add(number: "10")
        calculator.add(operand: "%")
        calculator.add(number: "3")
        calculator.addResult()
        XCTAssertEqual(calculator.expression, "10 % 3 = Bad operation")
    }
    
    func testGivenExpressionContainsBadCharacter_WhenCalculating_ThenResultIsBadOperation() {
        calculator.add(number: "6")
        calculator.add(operand: "x")
        calculator.add(number: "P")
        calculator.addResult()
        XCTAssertEqual(calculator.expression, "6 x P = Bad operation")
    }
    
    func testGivenExpressionIsTenPlus_WhenAddingMinus_ThenExpressionIsTenMinus() {
        calculator.add(number: "10")
        calculator.add(operand: "+")
        calculator.add(operand: "-")
        XCTAssertEqual(calculator.expression, "10 - ")
    }
}
