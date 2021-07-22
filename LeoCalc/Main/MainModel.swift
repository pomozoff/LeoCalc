//
//  MainModel.swift
//  LeoCalc
//
//  Created by Anton Pomozov on 19.07.2021.
//

/*
 TASKS
 + 1. sin, cos
 + 2. AC/C
 + 3. fractional
   4. bitcoin
 */

import Combine
import CommonKit
import Foundation

protocol Calculable {
    var total: AnyPublisher<Decimal, Never> { get }
    var isCleaned: AnyPublisher<Bool, Never> { get }
    var isAwaiting: AnyPublisher<Bool, Never> { get }

    func didReceive(action: Action)
}

class MainModel {
    init() {
        reset()
    }

    private var inputStack = Stack<Action>()
    private var previousAction: Action?

    @Published
    private(set) var _total: Decimal = 0

    @Published
    private(set) var _isCleaned = true

    @Published
    private(set) var _isAwaiting = false

    private let decimalFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.numberStyle = .decimal
        return formatter
    }()
}

extension MainModel: Calculable {
    var total: AnyPublisher<Decimal, Never> {
        $_total.eraseToAnyPublisher()
    }

    var isCleaned: AnyPublisher<Bool, Never> {
        $_isCleaned.eraseToAnyPublisher()
    }

    var isAwaiting: AnyPublisher<Bool, Never> {
        $_isAwaiting.eraseToAnyPublisher()
    }

    func didReceive(action: Action) {
        if action == .clear {
            guard !_isCleaned else { return reset() }

            _isCleaned = true
            _total = 0
        } else {
            _isCleaned = false
        }

        if action.isOperator && !inputStack.isEmpty {
            run(action)
        } else if action.isDigit {
            add(action)
        }

        previousAction = action
    }
}

private extension MainModel {
    func reset() {
        _total = 0
        _isCleaned = true
        _isAwaiting = false

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
            _total *= 10
            _total += digit
        } else {
            _total = digit
        }
    }

    func run(_ action: Action) {
        var topAction: Action?
        let behavior: Behavior?

        if action.type == .binaryOperator {
            guard inputStack.top?.isOperator != true else {
                _ = inputStack.pop()
                inputStack.push(action)
                return
            }

            guard let lastOperator = inputStack.last(where: \.isOperator),
                  action.priority <= lastOperator.priority
            else {
                inputStack.push(action)
                return
            }
            behavior = lastOperator.rawValue
        } else {
            if inputStack.top?.isOperator == true {
                topAction = inputStack.pop()
            }

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

        func handleResult(_ result: Decimal) {
            guard var stack = numberToStack(result) else {
                assertionFailure("Failed to put the result to a stack")
                return reset()
            }

            _total = result

            var reversedStack = stack.reversed()
            while let digit = reversedStack.pop() {
                inputStack.push(digit)
            }

            if action.type == .binaryOperator {
                run(action)
            } else if let topAction = topAction {
                inputStack.push(topAction)
            }
        }

        _isAwaiting = true
        behavior?.calculate(operands) { [unowned self] result in
            switch result {
            case let .success(value):
                handleResult(value)
            case let .failure(error):
                print(error)
            }
            _isAwaiting = false
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

    func numberToStack(_ number: Decimal) -> Stack<Action>? {
        var stack = Stack<Action>()

        for char in String(describing: number) {
            guard let action = Action(name: String(char)) else { return nil }
            stack.push(action)
        }

        return stack
    }
}
