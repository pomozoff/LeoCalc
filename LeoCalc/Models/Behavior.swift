//
//  Behavior.swift
//  LeoCalc
//
//  Created by Anton Pomozov on 19.07.2021.
//

import Foundation
import NetworkKit

final class Behavior {
    let kind: Kind

    func calculate(_ operands: [Decimal], with completion: @escaping (Result<Decimal, Error>) -> Void) -> Void {
        dataSource?.calculate(operands, with: completion)
    }

    init(
        kind: Kind,
        dataSource: AnyDataSource<Decimal>? = nil
    ) {
        self.kind = kind
        self.dataSource = dataSource
    }

    private let dataSource: AnyDataSource<Decimal>?
}

extension Behavior {
    enum Kind: String, CaseIterable {
        case clear = "AC"
        case sin = "sin"
        case cos = "cos"
        case bitcoin = "₿"
        case plus = "+"
        case minus = "-"
        case division = "÷"
        case multiplication = "×"
        case zero = "0"
        case one = "1"
        case two = "2"
        case three = "3"
        case four = "4"
        case five = "5"
        case six = "6"
        case seven = "7"
        case eight = "8"
        case nine = "9"
        case point = "."
        case equal = "="

        var `default`: Behavior {
            switch self {
            case .clear: return .clear
            case .sin: return .sin
            case .cos: return .cos
            case .bitcoin: return .bitcoin
            case .plus: return .plus
            case .minus: return .minus
            case .division: return .division
            case .multiplication: return .multiplication
            case .zero: return .zero
            case .one: return .one
            case .two: return .two
            case .three: return .three
            case .four: return .four
            case .five: return .five
            case .six: return .six
            case .seven: return .seven
            case .eight: return .eight
            case .nine: return .nine
            case .point: return .point
            case .equal: return .equal
            }
        }
    }
}

extension Behavior {
    static let clear = Behavior(kind: .clear, dataSource: ConstantDataSource(value: 0).anyDataSource)
    static let sin = Behavior(kind: .sin, dataSource: UnaryOperationDataSource { Math.calcSin(from: $0) }.anyDataSource)
    static let cos = Behavior(kind: .cos, dataSource: UnaryOperationDataSource { Math.calcCos(from: $0) }.anyDataSource)
    static let bitcoin = Behavior(
        kind: .bitcoin,
        dataSource: BitcoinDataSource(
            bitcoinProvider: Provider<BitcoinAPI>(),
            parsable: Parser(),
            currencyCode: "USD"
        ).anyDataSource
    )
    static let plus = Behavior(kind: .plus, dataSource: BinaryOperationDataSource { $0 + $1 }.anyDataSource)
    static let minus = Behavior(kind: .minus, dataSource: BinaryOperationDataSource { $0 - $1 }.anyDataSource)
    static let division = Behavior(kind: .division, dataSource: BinaryOperationDataSource { $0 / $1 }.anyDataSource)
    static let multiplication = Behavior(kind: .multiplication, dataSource: BinaryOperationDataSource { $0 * $1 }.anyDataSource)
    static let zero = Behavior(kind: .zero)
    static let one = Behavior(kind: .one)
    static let two = Behavior(kind: .two)
    static let three = Behavior(kind: .three)
    static let four = Behavior(kind: .four)
    static let five = Behavior(kind: .five)
    static let six = Behavior(kind: .six)
    static let seven = Behavior(kind: .seven)
    static let eight = Behavior(kind: .eight)
    static let nine = Behavior(kind: .nine)
    static let point = Behavior(kind: .point)
    static let equal = Behavior(kind: .equal)
}

extension Behavior: Hashable {
    static func == (lhs: Behavior, rhs: Behavior) -> Bool {
        lhs.kind == rhs.kind
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(kind)
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
