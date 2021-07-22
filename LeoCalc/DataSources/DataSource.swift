//
//  DataSource.swift
//  LeoCalc
//
//  Created by Anton Pomozov on 22.07.2021.
//

import Foundation

typealias UnaryCalculate = (Decimal) -> Decimal
typealias BinaryCalculate = (Decimal, Decimal) -> Decimal

enum DataSourceError: Error {
    case invalidNumberOfOperands
    case valueNotFound
}

protocol DataSource: AnyObject {
    associatedtype T

    var anyDataSource: AnyDataSource<T> { get }

    func calculate(_ operands: [Decimal], with completion: @escaping (Result<T, Swift.Error>) -> Void)
}

extension DataSource {
    var anyDataSource: AnyDataSource<T> {
        AnyDataSource(wrappedDataSource: self)
    }
}
