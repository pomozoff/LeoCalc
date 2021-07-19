//
//  Action.swift
//  LeoCalc
//
//  Created by Anton Pomozov on 19.07.2021.
//

import Foundation

enum Action: String, CaseIterable {
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
    case comma = ","
    case equal = "="
}

extension Action {
    var title: String { rawValue }
}
