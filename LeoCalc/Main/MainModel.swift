//
//  MainModel.swift
//  LeoCalc
//
//  Created by Anton Pomozov on 19.07.2021.
//

/*
 TASKS
 1. sin, cos
 2. AC/C
 3. fractional
 4. bitcoin
 */

import Combine
import CommonKit
import Foundation

class MainModel {
    @Published
    private(set) var total: Decimal = 0

    @Published
    private(set) var isCleaned = false

    init() {
        reset()
    }

    func didReceive(action: Action) {
        if action == .clear {
            guard !isCleaned else { return reset() }

            isCleaned = true
            total = 0
        }

        if action.isOperator && !inputStack.isEmpty {
            run(action)
        } else if action.isDigit {
            add(action)
        }

        previousAction = action
    }

    private var inputStack = Stack<Action>()
    private var previousAction: Action?

    private let decimalFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.numberStyle = .decimal
        return formatter
    }()
}

private extension MainModel {
    func reset() {
        total = 0
        isCleaned = false
        inputStack.removeAll()
        previousAction = nil
    }

    func add(_ action: Action) {
        inputStack.push(action)
        guard let digit = action.digit else {
            assertionFailure("Invalid action")
            return reset()
        }

        if previousAction?.isDigit == true {
            total *= 10
            total += digit
        } else {
            total = digit
        }
    }

    func run(_ action: Action) {
        let behavior: Behavior?
        if action.type == .binaryOperator {
            guard let lastOperator = inputStack.last(where: \.isOperator),
                  action.priority <= lastOperator.priority
            else {
                inputStack.push(action)
                return
            }
            behavior = lastOperator.rawValue
        } else {
            behavior = action.rawValue
        }

        guard let rightOperand = fetchOperand() else {
            assertionFailure("Failed to get a right operand")
            return reset()
        }

        var operands = [rightOperand]

        if action.type == .binaryOperator, let `operator` = fetchOperator() {
            if `operator`.type == .binaryOperator {
                guard let leftOperand = fetchOperand() else {
                    assertionFailure("Failed to get a left operand")
                    return reset()
                }
                operands.insert(leftOperand, at: 0)
            }
        }

        guard let result = behavior?.calculate(operands) else {
            assertionFailure("Failed to calculate a result")
            return reset()
        }
        guard var stack = numberToStack(result) else {
            assertionFailure("Failed to put the result to a stack")
            return reset()
        }

        total = result

        var reversedStack = stack.reversed()
        while let digit = reversedStack.pop() {
            inputStack.push(digit)
        }

        if action.type == .binaryOperator {
            run(action)
        }
    }

    func fetchOperand() -> Decimal? {
        guard !inputStack.isEmpty else {
            assertionFailure("Stack is empty")
            return nil
        }
        return stackToNumber(&inputStack)
    }

    func fetchOperator() -> Action? {
        guard let top = inputStack.top, top.isOperator else {
            assertionFailure("Invalid action type is on top of the stack")
            return nil
        }
        return inputStack.pop()
    }

    // TODO: Handle fractional numbers
    func stackToNumber(_ stack: inout Stack<Action>) -> Decimal? {
        var decimalString = ""
        var reversedStack = Stack<Action>()

        while stack.top?.isDigit == true, let action = stack.pop() {
            reversedStack.push(action)
        }
        while let action = reversedStack.pop() {
            decimalString += action.name
        }

        return decimalFormatter.number(from: decimalString)?.decimalValue
    }

    // TODO: Handle fractional numbers
    func numberToStack(_ number: Decimal) -> Stack<Action>? {
        var stack = Stack<Action>()

        for char in String(describing: number) {
            guard let action = Action(name: String(char)) else { return nil }
            stack.push(action)
        }

        return stack
    }
}
