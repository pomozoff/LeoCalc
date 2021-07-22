//
//  AnyDataSource.swift
//  LeoCalc
//
//  Created by Anton Pomozov on 22.07.2021.
//

import Foundation

class AnyDataSource<T>: DataSource {
    init<TSource: DataSource>(wrappedDataSource: TSource) where TSource.T == T {
        self.getValue = wrappedDataSource.calculate
    }

    func calculate(_ operands: [Decimal], with completion: @escaping (Result<T, Swift.Error>) -> Void) {
        getValue(operands, completion)
    }

    private let getValue: ([Decimal], @escaping (Result<T, Swift.Error>) -> Void) -> Void
}

