//
//  BinaryOperationDataSource.swift
//  LeoCalc
//
//  Created by Anton Pomozov on 22.07.2021.
//

import Foundation

class BinaryOperationDataSource {
    init(calculate: @escaping BinaryCalculate) {
        self.calculate = calculate
    }
    private let calculate: BinaryCalculate
}

extension BinaryOperationDataSource: DataSource {
    func calculate(operands: [Decimal], completion: (Result<Decimal, Error>) -> Void) {
        guard operands.count == 2 else { return completion(.failure(DataSourceError.invalidNumberOfOperands)) }
        return completion(.success(calculate(operands[0], operands[1])))
    }
}
