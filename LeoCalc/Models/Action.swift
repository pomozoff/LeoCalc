//
//  Action.swift
//  LeoCalc
//
//  Created by Anton Pomozov on 19.07.2021.
//

import FeatureToggleKit
import Foundation

struct Action {
    let isEnabled: Bool

    var type: Behavior.Kind { behavior.kind }

    private let behavior: Behavior
}

extension Action {
    init(type: Behavior.Kind, isEnabled: Bool = true) {
        self.behavior = type.default
        self.isEnabled = isEnabled
    }

    init(behavior: Behavior, isEnabled: Bool = true) {
        self.behavior = behavior
        self.isEnabled = isEnabled
    }

    init?(name: String, isEnabled: Bool = true) {
        guard let behavior = Behavior.Kind.allCases.first(where: { $0.rawValue == name })?.default else { return nil }
        self.behavior = behavior
        self.isEnabled = isEnabled
    }

    func calculate(_ operands: [Decimal], with completion: @escaping (Result<Decimal, Error>) -> Void) -> Void {
        behavior.calculate(operands, with: completion)
    }

    func copy(isEnabled: Bool) -> Action {
        Action(behavior: behavior, isEnabled: isEnabled)
    }
}

extension Action {
    enum `Class` {
        case digit
        case unaryOperator
        case binaryOperator
    }

    var `class`: Class {
        switch behavior.kind {
        case .clear, .sin, .cos, .bitcoin:
            return .unaryOperator
        case .plus, .minus, .division, .multiplication, .equal:
            return .binaryOperator
        case .zero, .one, .two, .three, .four, .five, .six, .seven, .eight, .nine, .point:
            return .digit
        }
    }

    var priority: Int {
        switch behavior.kind {
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

    var digit: Decimal? { Decimal(string: behavior.kind.rawValue) }

    var isOperator: Bool { `class` == .unaryOperator || `class` == .binaryOperator }

    var isDigit: Bool { `class` == .digit }
}

extension Action: Feature {
    var name: String { behavior.kind.rawValue }
}
