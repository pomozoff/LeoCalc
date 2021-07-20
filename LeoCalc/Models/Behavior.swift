//
//  Behavior.swift
//  LeoCalc
//
//  Created by Anton Pomozov on 19.07.2021.
//

import Foundation

struct Behavior {
    let name: String
    let calculate: ([Decimal]) -> Decimal?

    private init(name: String, calculate: @escaping ([Decimal]) -> Decimal?) {
        self.name = name
        self.calculate = calculate
    }
}

extension Behavior {
    static let clear = Behavior(name: "AC") { _ in 0 }
    static let sin = Behavior(name: "sin") { operands in
        guard operands.count == 1 else { return nil }
        return Math.calcSin(from: operands[0])
    }
    static let cos = Behavior(name: "cos") { operands in
        guard operands.count == 1 else { return nil }
        return Math.calcCos(from: operands[0])
    }
    static let bitcoin = Behavior(name: "₿") { _ in
        0
    }
    static let plus = Behavior(name: "+") { operands in
        guard operands.count == 2 else { return nil }
        return operands[0] + operands[1]
    }
    static let minus = Behavior(name: "-") { operands in
        guard operands.count == 2 else { return nil }
        return operands[0] - operands[1]
    }
    static let division = Behavior(name: "÷") { operands in
        guard operands.count == 2 else { return nil }
        return operands[0] / operands[1]
    }
    static let multiplication = Behavior(name: "×") { operands in
        guard operands.count == 2 else { return nil }
        return operands[0] * operands[1]
    }
    static let zero = Behavior(name: "0") { _ in nil }
    static let one = Behavior(name: "1") { _ in nil }
    static let two = Behavior(name: "2") { _ in nil }
    static let three = Behavior(name: "3") { _ in nil }
    static let four = Behavior(name: "4") { _ in nil }
    static let five = Behavior(name: "5") { _ in nil }
    static let six = Behavior(name: "6") { _ in nil }
    static let seven = Behavior(name: "7") { _ in nil }
    static let eight = Behavior(name: "8") { _ in nil }
    static let nine = Behavior(name: "9") { _ in nil }
    static let point = Behavior(name: ".") { _ in nil }
    static let equal = Behavior(name: "=") { _ in nil }
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
