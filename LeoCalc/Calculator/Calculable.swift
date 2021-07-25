//
//  Calculable.swift
//  LeoCalc
//
//  Created by Anton Pomozov on 25.07.2021.
//

import Combine
import Foundation

protocol Calculable {
    var total: AnyPublisher<Decimal, Never> { get }
    var showPoint: AnyPublisher<Bool, Never> { get }
    var isCleaned: AnyPublisher<Bool, Never> { get }
    var isAwaiting: AnyPublisher<Bool, Never> { get }
    var calcError: AnyPublisher<CalcError, Never> { get }

    func didReceive(action: Action)
}
