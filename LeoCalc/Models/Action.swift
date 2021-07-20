//
//  Action.swift
//  LeoCalc
//
//  Created by Anton Pomozov on 19.07.2021.
//

import Foundation

enum Action: CaseIterable {
    case clear
    case sin
    case cos
    case bitcoin
    case plus
    case minus
    case division
    case multiplication
    case zero
    case one
    case two
    case three
    case four
    case five
    case six
    case seven
    case eight
    case nine
    case point
    case equal
}

extension Action {
    init?(name: String) {
        guard let action = Action.allCases.first(where: { $0.name == name }) else { return nil }
        self = action
    }
}

extension Action: RawRepresentable {
    var rawValue: Behavior {
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

    init?(rawValue: Behavior) {
        switch rawValue {
        case .clear: self = .clear
        case .sin: self = .sin
        case .cos: self = .cos
        case .bitcoin: self = .bitcoin
        case .plus: self = .plus
        case .minus: self = .minus
        case .division: self = .division
        case .multiplication: self = .multiplication
        case .zero: self = .zero
        case .one: self = .one
        case .two: self = .two
        case .three: self = .three
        case .four: self = .four
        case .five: self = .five
        case .six: self = .six
        case .seven: self = .seven
        case .eight: self = .eight
        case .nine: self = .nine
        case .point: self = .point
        case .equal: self = .equal
        default: return nil
        }
    }
}

extension Action {
    enum `Type` {
        case digit
        case unaryOperator
        case binaryOperator
    }

    var type: Type {
        switch self {
        case .clear, .sin, .cos, .bitcoin:
            return .unaryOperator
        case .plus, .minus, .division, .multiplication, .equal:
            return .binaryOperator
        case .zero, .one, .two, .three, .four, .five, .six, .seven, .eight, .nine, .point:
            return .digit
        }
    }

    var priority: Int {
        switch self {
        case .clear:
            return 100
        case .sin, .cos, .bitcoin:
            return 80
        case .division, .multiplication:
            return 70
        case .plus, .minus:
            return 60
        case .equal:
            return 50
        case .zero, .one, .two, .three, .four, .five, .six, .seven, .eight, .nine, .point:
            return 0
        }
    }

    var title: String { rawValue.name }

    var digit: Decimal? { Decimal(string: rawValue.name) }

    var isOperator: Bool { type == .unaryOperator || type == .binaryOperator }

    var isDigit: Bool { type == .digit }
}
