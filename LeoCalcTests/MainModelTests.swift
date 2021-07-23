//
//  MainModelTests.swift
//  LeoCalcTests
//
//  Created by Anton Pomozov on 15.07.2021.
//

import Combine
import CommonKit
import NetworkKit
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
        model.didReceive(action: Action(type: .plus))

        XCTAssert(model._total == 0, "Invalid result, should be 0")
    }

    func testPlusMinus() throws {
        model.didReceive(action: Action(type: .plus))
        model.didReceive(action: Action(type: .minus))

        XCTAssert(model._total == 0, "Invalid result, should be 0")
    }

    func testPlusMinusTwoPlusFourEqual() throws {
        model.didReceive(action: Action(type: .plus))
        model.didReceive(action: Action(type: .minus))
        model.didReceive(action: Action(type: .two))
        model.didReceive(action: Action(type: .plus))
        model.didReceive(action: Action(type: .four))
        model.didReceive(action: Action(type: .equal))

        XCTAssert(model._total == 6, "Invalid result, should be 6")
    }

    func testTwo() throws {
        model.didReceive(action: Action(type: .two))

        XCTAssert(model._total == 2, "Invalid result, should be 2")
    }

    func testTwoPlus() throws {
        model.didReceive(action: Action(type: .two))
        model.didReceive(action: Action(type: .plus))

        XCTAssert(model._total == 2, "Invalid result, should be 2")
    }

    func testTwoPlusThree() throws {
        model.didReceive(action: Action(type: .two))
        model.didReceive(action: Action(type: .plus))
        model.didReceive(action: Action(type: .three))
        model.didReceive(action: Action(type: .plus))

        XCTAssert(model._total == 5, "Invalid result, should be 5")
    }

    func testTwoPlusThreePlus() throws {
        model.didReceive(action: Action(type: .two))
        model.didReceive(action: Action(type: .plus))
        model.didReceive(action: Action(type: .three))
        model.didReceive(action: Action(type: .plus))

        XCTAssert(model._total == 5, "Invalid result, should be 5")
    }

    func testTwoPlusThreeEqual() throws {
        model.didReceive(action: Action(type: .two))
        model.didReceive(action: Action(type: .plus))
        model.didReceive(action: Action(type: .three))
        model.didReceive(action: Action(type: .equal))

        XCTAssert(model._total == 5, "Invalid result, should be 5")
    }

    func testThreePlusMinusOneEqual() throws {
        model.didReceive(action: Action(type: .three))
        model.didReceive(action: Action(type: .plus))
        model.didReceive(action: Action(type: .minus))
        model.didReceive(action: Action(type: .one))
        model.didReceive(action: Action(type: .equal))

        XCTAssert(model._total == 2, "Invalid result, should be 2")
    }

    func testTwoPlusThreeMult() throws {
        model.didReceive(action: Action(type: .two))
        model.didReceive(action: Action(type: .plus))
        model.didReceive(action: Action(type: .three))
        model.didReceive(action: Action(type: .multiplication))

        XCTAssert(model._total == 3, "Invalid result, should be 3")
    }

    func testTwoPlusThreeMultTwo() throws {
        model.didReceive(action: Action(type: .two))
        model.didReceive(action: Action(type: .plus))
        model.didReceive(action: Action(type: .three))
        model.didReceive(action: Action(type: .multiplication))
        model.didReceive(action: Action(type: .two))

        XCTAssert(model._total == 2, "Invalid result, should be 2")
    }

    func testTwoPlusThreeMultTwoMult() throws {
        model.didReceive(action: Action(type: .two))
        model.didReceive(action: Action(type: .plus))
        model.didReceive(action: Action(type: .three))
        model.didReceive(action: Action(type: .multiplication))
        model.didReceive(action: Action(type: .two))
        model.didReceive(action: Action(type: .multiplication))

        XCTAssert(model._total == 6, "Invalid result, should be 6")
    }

    func testTwoPlusThreeMultTwoMultTwo() throws {
        model.didReceive(action: Action(type: .two))
        model.didReceive(action: Action(type: .plus))
        model.didReceive(action: Action(type: .three))
        model.didReceive(action: Action(type: .multiplication))
        model.didReceive(action: Action(type: .two))
        model.didReceive(action: Action(type: .multiplication))
        model.didReceive(action: Action(type: .two))

        XCTAssert(model._total == 2, "Invalid result, should be 2")
    }

    func testTwoPlusThreeMultTwoMultTwoPlus() throws {
        model.didReceive(action: Action(type: .two))
        model.didReceive(action: Action(type: .plus))
        model.didReceive(action: Action(type: .three))
        model.didReceive(action: Action(type: .multiplication))
        model.didReceive(action: Action(type: .two))
        model.didReceive(action: Action(type: .multiplication))
        model.didReceive(action: Action(type: .two))
        model.didReceive(action: Action(type: .plus))

        XCTAssert(model._total == 14, "Invalid result, should be 14")
    }

    func testTwoPlusThreeMultTwoMultTwoPlusThree() throws {
        model.didReceive(action: Action(type: .two))
        model.didReceive(action: Action(type: .plus))
        model.didReceive(action: Action(type: .three))
        model.didReceive(action: Action(type: .multiplication))
        model.didReceive(action: Action(type: .two))
        model.didReceive(action: Action(type: .multiplication))
        model.didReceive(action: Action(type: .two))
        model.didReceive(action: Action(type: .plus))
        model.didReceive(action: Action(type: .three))

        XCTAssert(model._total == 3, "Invalid result, should be 3")
    }

    func testTwoPlusThreeMultTwoMultTwoPlusThreeEqual() throws {
        model.didReceive(action: Action(type: .two))
        model.didReceive(action: Action(type: .plus))
        model.didReceive(action: Action(type: .three))
        model.didReceive(action: Action(type: .multiplication))
        model.didReceive(action: Action(type: .two))
        model.didReceive(action: Action(type: .multiplication))
        model.didReceive(action: Action(type: .two))
        model.didReceive(action: Action(type: .plus))
        model.didReceive(action: Action(type: .three))
        model.didReceive(action: Action(type: .equal))

        XCTAssert(model._total == 17, "Invalid result, should be 17")
    }

    func testTwoMultThreePlus() throws {
        model.didReceive(action: Action(type: .two))
        model.didReceive(action: Action(type: .multiplication))
        model.didReceive(action: Action(type: .three))
        model.didReceive(action: Action(type: .plus))

        XCTAssert(model._total == 6, "Invalid result, should be 6")
    }

    func testTwoMultThreeMult() throws {
        model.didReceive(action: Action(type: .two))
        model.didReceive(action: Action(type: .multiplication))
        model.didReceive(action: Action(type: .three))
        model.didReceive(action: Action(type: .multiplication))

        XCTAssert(model._total == 6, "Invalid result, should be 6")
    }

    func testNineZeroCos() throws {
        model.didReceive(action: Action(type: .nine))
        model.didReceive(action: Action(type: .zero))
        model.didReceive(action: Action(type: .cos))

        XCTAssert(model._total == 0, "Invalid result, should be 0")
    }

    func testNineZeroSin() throws {
        model.didReceive(action: Action(type: .nine))
        model.didReceive(action: Action(type: .zero))
        model.didReceive(action: Action(type: .sin))

        XCTAssert(model._total == 1, "Invalid result, should be 1")
    }

    func testFourFiveMultTwoSin() throws {
        model.didReceive(action: Action(type: .four))
        model.didReceive(action: Action(type: .five))
        model.didReceive(action: Action(type: .multiplication))
        model.didReceive(action: Action(type: .two))
        model.didReceive(action: Action(type: .plus))
        model.didReceive(action: Action(type: .sin))
        model.didReceive(action: Action(type: .three))
        model.didReceive(action: Action(type: .equal))

        XCTAssert(model._total == 4, "Invalid result, should be 4")
    }

    func testTwoPlusThreeClearFourEqual() throws {
        model.didReceive(action: Action(type: .two))
        model.didReceive(action: Action(type: .plus))
        model.didReceive(action: Action(type: .three))
        model.didReceive(action: Action(type: .clear))
        model.didReceive(action: Action(type: .four))
        model.didReceive(action: Action(type: .equal))

        XCTAssert(model._total == 6, "Invalid result, should be 6")
    }

    func testTwoClearClearFour() throws {
        model.didReceive(action: Action(type: .two))
        model.didReceive(action: Action(type: .clear))
        model.didReceive(action: Action(type: .clear))
        model.didReceive(action: Action(type: .four))

        XCTAssert(model._total == 4, "Invalid result, should be 4")
    }

    func testTwoPlusThreeClearClearFourEqual() throws {
        model.didReceive(action: Action(type: .two))
        model.didReceive(action: Action(type: .plus))
        model.didReceive(action: Action(type: .three))
        model.didReceive(action: Action(type: .clear))
        model.didReceive(action: Action(type: .clear))
        model.didReceive(action: Action(type: .four))
        model.didReceive(action: Action(type: .equal))

        XCTAssert(model._total == 4, "Invalid result, should be 4")
    }

    func testOnePointTwoPlusTwoPointThreeEqual() throws {
        model.didReceive(action: Action(type: .one))
        model.didReceive(action: Action(type: .point))
        model.didReceive(action: Action(type: .two))
        model.didReceive(action: Action(type: .plus))
        model.didReceive(action: Action(type: .two))
        model.didReceive(action: Action(type: .point))
        model.didReceive(action: Action(type: .three))
        model.didReceive(action: Action(type: .equal))

        XCTAssert(model._total == Decimal(3.5), "Invalid result, should be 3.5")
    }

    func testFivePlusDivisionTwoEqual() throws {
        model.didReceive(action: Action(type: .five))
        model.didReceive(action: Action(type: .plus))
        model.didReceive(action: Action(type: .division))
        model.didReceive(action: Action(type: .two))
        model.didReceive(action: Action(type: .equal))

        XCTAssert(model._total == Decimal(2.5), "Invalid result, should be 2.5")
    }

    func testFivePlusTwoEqualMinusThreeEqual() throws {
        model.didReceive(action: Action(type: .five))
        model.didReceive(action: Action(type: .plus))
        model.didReceive(action: Action(type: .two))
        model.didReceive(action: Action(type: .equal))
        model.didReceive(action: Action(type: .minus))
        model.didReceive(action: Action(type: .three))
        model.didReceive(action: Action(type: .equal))

        XCTAssert(model._total == Decimal(4), "Invalid result, should be 4")
    }

    func testFivePlusPoint() throws {
        model.didReceive(action: Action(type: .five))
        model.didReceive(action: Action(type: .plus))
        model.didReceive(action: Action(type: .point))

        XCTAssert(model._showPoint, "Invalid result, should show point")
        XCTAssert(model._total == Decimal(0), "Invalid result, should be 0")
    }

    func testFivePoint() throws {
        model.didReceive(action: Action(type: .five))
        model.didReceive(action: Action(type: .point))

        XCTAssert(model._showPoint, "Invalid result, should show point")
        XCTAssert(model._total == Decimal(5), "Invalid result, should be 5")
    }

    func testFivePointFiveFiveFive() throws {
        model.didReceive(action: Action(type: .five))
        model.didReceive(action: Action(type: .point))
        model.didReceive(action: Action(type: .five))
        model.didReceive(action: Action(type: .five))
        model.didReceive(action: Action(type: .five))

        XCTAssert(model._showPoint == false, "Invalid result, should not show point")
        XCTAssert(model._total == Decimal(5.555), "Invalid result, should be 5.555")
    }

    func testFivePlusPointEqual() throws {
        model.didReceive(action: Action(type: .five))
        model.didReceive(action: Action(type: .plus))
        model.didReceive(action: Action(type: .point))
        model.didReceive(action: Action(type: .equal))

        XCTAssert(model._showPoint == false, "Invalid result, should not show point")
        XCTAssert(model._total == Decimal(5), "Invalid result, should be 5")
    }

    func testFivePlusPointTwoEqua() throws {
        model.didReceive(action: Action(type: .five))
        model.didReceive(action: Action(type: .plus))
        model.didReceive(action: Action(type: .point))
        model.didReceive(action: Action(type: .two))
        model.didReceive(action: Action(type: .equal))

        XCTAssert(model._total == Decimal(5.2), "Invalid result, should be 5.2")
    }

    func testOneMinusFiveEqual() throws {
        model.didReceive(action: Action(type: .one))
        model.didReceive(action: Action(type: .minus))
        model.didReceive(action: Action(type: .five))
        model.didReceive(action: Action(type: .equal))

        XCTAssert(model._total == Decimal(-4), "Invalid result, should be -4")
    }

    func testOneMinusFiveMultTwoEqual() throws {
        model.didReceive(action: Action(type: .one))
        model.didReceive(action: Action(type: .minus))
        model.didReceive(action: Action(type: .five))
        model.didReceive(action: Action(type: .multiplication))
        model.didReceive(action: Action(type: .two))
        model.didReceive(action: Action(type: .equal))

        XCTAssert(model._total == Decimal(-9), "Invalid result, should be -9")
    }

    func testOneMinusFivePlusTwoEqual() throws {
        model.didReceive(action: Action(type: .one))
        model.didReceive(action: Action(type: .minus))
        model.didReceive(action: Action(type: .five))
        model.didReceive(action: Action(type: .plus))
        model.didReceive(action: Action(type: .two))
        model.didReceive(action: Action(type: .equal))

        XCTAssert(model._total == Decimal(-2), "Invalid result, should be -2")
    }

    func testOneBitcoin() throws {
        let expectation = XCTestExpectation(description: "Fetch feature list")
        bitcoinCancellable = model.total
            .dropFirst(2)
            .sink {
                XCTAssert($0 == 32259.2666, "Invalid result, should be 32259.2666")
                expectation.fulfill()
            }

        let behavior = Behavior(
            kind: .bitcoin,
            dataSource: BitcoinDataSource(
                bitcoinProvider: Provider<BitcoinAPI>(urlSession: Constants.bitcoinSession),
                parsable: Parser(),
                currencyCode: "USD"
            ).anyDataSource
        )

        let bitcoinAction = Action(behavior: behavior, isEnabled: true)
        model.didReceive(action: Action(type: .one))
        model.didReceive(action: bitcoinAction)

        wait(for: [expectation], timeout: Constants.defaultTimeout)
    }

    private var model: MainModel!
    private var bitcoinCancellable = AnyCancellable {}
}

private enum Constants {
    static let defaultTimeout = 1.0

    static let bitcoinSession: URLSession = {
        let bitconFetch = BitcoinAPI.fetch
        let url = bitconFetch.url!
        let data = Bundle(for: MainModelTests.self).readData(from: "bitcoin.json")
        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
        URLProtocolMock.mockURLs = [url: (nil, data, response)]

        let sessionConfiguration = URLSessionConfiguration.ephemeral
        sessionConfiguration.protocolClasses = [URLProtocolMock.self]

        return URLSession(configuration: sessionConfiguration)
    }()
}
