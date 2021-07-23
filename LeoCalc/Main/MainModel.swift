//
//  MainModel.swift
//  LeoCalc
//
//  Created by Anton Pomozov on 19.07.2021.
//

import Combine
import CommonKit
import Foundation

protocol Calculable {
    var total: AnyPublisher<Decimal, Never> { get }
    var showPoint: AnyPublisher<Bool, Never> { get }
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
    private(set) var _showPoint = false

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

    private var pointPosition = -1 {
        didSet {
            _showPoint = pointPosition == 0
        }
    }
}

extension MainModel: Calculable {
    var total: AnyPublisher<Decimal, Never> {
        $_total.eraseToAnyPublisher()
    }

    var showPoint: AnyPublisher<Bool, Never> {
        $_showPoint.eraseToAnyPublisher()
    }

    var isCleaned: AnyPublisher<Bool, Never> {
        $_isCleaned.eraseToAnyPublisher()
    }

    var isAwaiting: AnyPublisher<Bool, Never> {
        $_isAwaiting.eraseToAnyPublisher()
    }

    func didReceive(action: Action) {
        if action.type == .clear {
            guard !_isCleaned else { return reset() }

            _isCleaned = true
            _total = 0
            pointPosition = -1
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

        pointPosition = -1

        inputStack.removeAll()
        previousAction = nil
    }

    func add(_ action: Action) {
        _isCleaned = false

        guard action.type != .point else {
            guard pointPosition < 0 else { return }

            if previousAction?.isOperator == true {
                _total = 0
            }

            pointPosition = 0
            inputStack.push(action)

            return
        }

        guard let digit = action.digit else {
            assertionFailure("Invalid action")
            return reset()
        }

        pointPosition += pointPosition < 0 ? 0 : 1
        inputStack.push(action)

        if previousAction?.isDigit == true {
            _total *= pointPosition > 0 ? 1 : 10
            _total += digit / (pointPosition > 0 ? pow(10, pointPosition) : 1)
        } else {
            _total = digit
        }
    }

    func run(_ action: Action) {
        var topAction: Action?
        let currentAction: Action?

        pointPosition = -1
        if action.class == .binaryOperator {
            guard inputStack.top?.isOperator != true else {
                _ = inputStack.pop()
                inputStack.push(action)
                return
            }

            guard let (index, lastOperator) = inputStack.lastEnumerated(where: \.isOperator),
                  index > 0,
                  action.priority <= lastOperator.priority
            else {
                inputStack.push(action)
                return
            }
            currentAction = lastOperator
        } else {
            if inputStack.top?.isOperator == true {
                topAction = inputStack.pop()
            }

            currentAction = action
        }

        guard let rightOperand = fetchOperand() else {
            assertionFailure("Failed to get a right operand")
            return reset()
        }

        var operands = [rightOperand]

        if action.class == .binaryOperator, let `operator` = fetchOperator() {
            if `operator`.class == .binaryOperator {
                guard let leftOperand = fetchOperand() else {
                    assertionFailure("Failed to get a left operand")
                    return reset()
                }
                operands.insert(leftOperand, at: 0)
            }
        }

        func processValue(_ value: Decimal) {
            guard var stack = numberToStack(value) else {
                assertionFailure("Failed to put the result to a stack")
                return reset()
            }

            _total = value

            var reversedStack = stack.reversed()
            while let digit = reversedStack.pop() {
                inputStack.push(digit)
            }

            if action.class == .binaryOperator {
                run(action)
            } else if let topAction = topAction, topAction.type != .equal {
                inputStack.push(topAction)
            }
        }

        func handleResult(_ result: Result<Decimal, Error>) {
            switch result {
            case let .success(value):
                processValue(value)
            case let .failure(error):
                print(error)
            }
            _isAwaiting = false
        }

        _isAwaiting = true
        currentAction?.calculate(operands) { result in
            if Thread.isMainThread {
                handleResult(result)
            } else {
                DispatchQueue.main.async {
                    handleResult(result)
                }
            }
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

        if stack.count == 1 && stack.top?.type == .minus {
            stack.pop().map { reversedStack.push($0) }
        }

        while let action = reversedStack.pop() {
            decimalString += action.name
        }
        decimalString = decimalString == "." ? "0" : decimalString

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
