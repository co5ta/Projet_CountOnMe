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
        calculator.expression = "5 + 8"
        XCTAssertEqual(calculator.getResult(), "13")
    }

    func testGivenFirstNumberIsSix_WhenSubstractingWithNumberFour_ThenTotalIsTwo() {
        calculator.expression = "6 - 4"
        XCTAssertEqual(calculator.getResult(), "2")
    }
    
    func testGivenFirstNumberIsFive_WhenMultiplicatingBySevenAndTwo_ThenTotalIsSeventy() {
        calculator.expression = "5 x 7 x 2"
        XCTAssertEqual(calculator.getResult(), "70")
    }
    
    func testGivenExpressionIsFiveDividedByTwo_WhenCalculatingTotal_ThenResultIsTwoPointFive() {
        calculator.expression = "5 ÷ 2"
        XCTAssertEqual(calculator.getResult(), "2.5")
    }
    
    func testGivenExpressionIsTenDividedByFive_WhenCalculatingTotal_ThenResultIsTwo() {
        calculator.expression = "10 ÷ 5"
        let result = calculator.getResult()
        XCTAssertEqual(result, "2")
        XCTAssertNotEqual(result, "2.0")
    }
    
    func testGivenExpressionContainsMultipleOperators_WhenGettingTotal_OrderOfOperationsIsRespected() {
        calculator.expression = "5 + 8 - 2 x 6 + 12 ÷ 3"
        XCTAssertEqual(calculator.getResult(), "5")
    }
}
