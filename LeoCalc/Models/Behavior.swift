//
//  Behavior.swift
//  LeoCalc
//
//  Created by Anton Pomozov on 19.07.2021.
//

import Foundation
import NetworkKit

final class Behavior {
    let name: String

    private(set) lazy var calculate: ([Decimal], @escaping (Result<Decimal, Error>) -> Void) -> Void = { [weak self] in
        self?.dataSource?.calculate(operands: $0, completion: $1)
    }

    private init(
        name: String,
        dataSource: AnyDataSource<Decimal>? = nil
    ) {
        self.name = name
        self.dataSource = dataSource
    }

    private let dataSource: AnyDataSource<Decimal>?
}

extension Behavior {
    static let clear = Behavior(name: "AC", dataSource: ConstantDataSource(value: 0).anyDataSource)
    static let sin = Behavior(name: "sin", dataSource: UnaryOperationDataSource { Math.calcSin(from: $0) }.anyDataSource)
    static let cos = Behavior(name: "cos", dataSource: UnaryOperationDataSource { Math.calcCos(from: $0) }.anyDataSource)
    static let bitcoin = Behavior(name: "₿", dataSource: BitcoinDataSource(bitcoinProvider: Provider<BitcoinAPI>(), parsable: Parser()).anyDataSource)
    static let plus = Behavior(name: "+", dataSource: BinaryOperationDataSource { $0 + $1 }.anyDataSource)
    static let minus = Behavior(name: "-", dataSource: BinaryOperationDataSource { $0 - $1 }.anyDataSource)
    static let division = Behavior(name: "÷", dataSource: BinaryOperationDataSource { $0 / $1 }.anyDataSource)
    static let multiplication = Behavior(name: "×", dataSource: BinaryOperationDataSource { $0 * $1 }.anyDataSource)
    static let zero = Behavior(name: "0")
    static let one = Behavior(name: "1")
    static let two = Behavior(name: "2")
    static let three = Behavior(name: "3")
    static let four = Behavior(name: "4")
    static let five = Behavior(name: "5")
    static let six = Behavior(name: "6")
    static let seven = Behavior(name: "7")
    static let eight = Behavior(name: "8")
    static let nine = Behavior(name: "9")
    static let point = Behavior(name: ".")
    static let equal = Behavior(name: "=")
}

extension Behavior: Hashable {
    static func == (lhs: Behavior, rhs: Behavior) -> Bool {
        lhs.name == rhs.name
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
}

private enum Math {
    static func calcSin(from value: Decimal) -> Decimal {
        let doubleValue = Double(truncating: value as NSNumber)
        let radians = deg2rad(doubleValue)
        let result = sin(radians)

        return Decimal(result.rounded(to: Constants.maxRoundedPlaces))
    }

    static func calcCos(from value: Decimal) -> Decimal {
        let doubleValue = Double(truncating: value as NSNumber)
        let radians = deg2rad(doubleValue)
        let result = cos(radians)

        return Decimal(result.rounded(to: Constants.maxRoundedPlaces))
    }

    static func deg2rad(_ number: Double) -> Double {
        number * .pi / 180
    }
}

private extension Double {
    func rounded(to places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

private enum Constants {
    static let maxRoundedPlaces = 10
}
