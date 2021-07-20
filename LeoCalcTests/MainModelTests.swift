//
//  MainModelTests.swift
//  LeoCalcTests
//
//  Created by Anton Pomozov on 15.07.2021.
//

import XCTest
@testable import LeoCalc

class MainModelTests: XCTestCase {
    override func setUpWithError() throws {
        model = MainModel()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testPlus() throws {
        model.didReceive(action: .plus)

        XCTAssert(model.total == 0, "Invalid result, should be 0")
    }

    func testPlusMinus() throws {
        model.didReceive(action: .plus)
        model.didReceive(action: .minus)

        XCTAssert(model.total == 0, "Invalid result, should be 0")
    }

    func testPlusMinusTwoPlusFourEqual() throws {
        model.didReceive(action: .plus)
        model.didReceive(action: .minus)
        model.didReceive(action: .two)
        model.didReceive(action: .plus)
        model.didReceive(action: .four)
        model.didReceive(action: .equal)

        XCTAssert(model.total == 6, "Invalid result, should be 6")
    }

    func testTwo() throws {
        model.didReceive(action: .two)

        XCTAssert(model.total == 2, "Invalid result, should be 2")
    }

    func testTwoPlus() throws {
        model.didReceive(action: .two)
        model.didReceive(action: .plus)

        XCTAssert(model.total == 2, "Invalid result, should be 2")
    }

    func testTwoPlusThree() throws {
        model.didReceive(action: .two)
        model.didReceive(action: .plus)
        model.didReceive(action: .three)
        model.didReceive(action: .plus)

        XCTAssert(model.total == 5, "Invalid result, should be 5")
    }

    func testTwoPlusThreePlus() throws {
        model.didReceive(action: .two)
        model.didReceive(action: .plus)
        model.didReceive(action: .three)
        model.didReceive(action: .plus)

        XCTAssert(model.total == 5, "Invalid result, should be 5")
    }

    func testTwoPlusThreeEqual() throws {
        model.didReceive(action: .two)
        model.didReceive(action: .plus)
        model.didReceive(action: .three)
        model.didReceive(action: .equal)

        XCTAssert(model.total == 5, "Invalid result, should be 5")
    }

    func testTwoPlusThreeMult() throws {
        model.didReceive(action: .two)
        model.didReceive(action: .plus)
        model.didReceive(action: .three)
        model.didReceive(action: .multiplication)

        XCTAssert(model.total == 3, "Invalid result, should be 3")
    }

    func testTwoPlusThreeMultTwo() throws {
        model.didReceive(action: .two)
        model.didReceive(action: .plus)
        model.didReceive(action: .three)
        model.didReceive(action: .multiplication)
        model.didReceive(action: .two)

        XCTAssert(model.total == 2, "Invalid result, should be 2")
    }

    func testTwoPlusThreeMultTwoMult() throws {
        model.didReceive(action: .two)
        model.didReceive(action: .plus)
        model.didReceive(action: .three)
        model.didReceive(action: .multiplication)
        model.didReceive(action: .two)
        model.didReceive(action: .multiplication)

        XCTAssert(model.total == 6, "Invalid result, should be 6")
    }

    func testTwoPlusThreeMultTwoMultTwo() throws {
        model.didReceive(action: .two)
        model.didReceive(action: .plus)
        model.didReceive(action: .three)
        model.didReceive(action: .multiplication)
        model.didReceive(action: .two)
        model.didReceive(action: .multiplication)
        model.didReceive(action: .two)

        XCTAssert(model.total == 2, "Invalid result, should be 2")
    }

    func testTwoPlusThreeMultTwoMultTwoPlus() throws {
        model.didReceive(action: .two)
        model.didReceive(action: .plus)
        model.didReceive(action: .three)
        model.didReceive(action: .multiplication)
        model.didReceive(action: .two)
        model.didReceive(action: .multiplication)
        model.didReceive(action: .two)
        model.didReceive(action: .plus)

        XCTAssert(model.total == 14, "Invalid result, should be 14")
    }

    func testTwoPlusThreeMultTwoMultTwoPlusThree() throws {
        model.didReceive(action: .two)
        model.didReceive(action: .plus)
        model.didReceive(action: .three)
        model.didReceive(action: .multiplication)
        model.didReceive(action: .two)
        model.didReceive(action: .multiplication)
        model.didReceive(action: .two)
        model.didReceive(action: .plus)
        model.didReceive(action: .three)

        XCTAssert(model.total == 3, "Invalid result, should be 3")
    }

    func testTwoPlusThreeMultTwoMultTwoPlusThreeEqual() throws {
        model.didReceive(action: .two)
        model.didReceive(action: .plus)
        model.didReceive(action: .three)
        model.didReceive(action: .multiplication)
        model.didReceive(action: .two)
        model.didReceive(action: .multiplication)
        model.didReceive(action: .two)
        model.didReceive(action: .plus)
        model.didReceive(action: .three)
        model.didReceive(action: .equal)

        XCTAssert(model.total == 17, "Invalid result, should be 17")
    }

    func testTwoMultThreePlus() throws {
        model.didReceive(action: .two)
        model.didReceive(action: .multiplication)
        model.didReceive(action: .three)
        model.didReceive(action: .plus)

        XCTAssert(model.total == 6, "Invalid result, should be 6")
    }

    func testTwoMultThreeMult() throws {
        model.didReceive(action: .two)
        model.didReceive(action: .multiplication)
        model.didReceive(action: .three)
        model.didReceive(action: .multiplication)

        XCTAssert(model.total == 6, "Invalid result, should be 6")
    }

    func testNineZeroCos() throws {
        model.didReceive(action: .nine)
        model.didReceive(action: .zero)
        model.didReceive(action: .cos)

        XCTAssert(model.total == 0, "Invalid result, should be 0")
    }

    private var model: MainModel!
}
