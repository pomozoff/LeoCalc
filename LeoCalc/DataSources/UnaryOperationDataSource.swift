//
//  UnaryOperationDataSource.swift
//  LeoCalc
//
//  Created by Anton Pomozov on 22.07.2021.
//

import Foundation

class UnaryOperationDataSource {
    init(calculate: @escaping UnaryCalculate) {
        self.calculate = calculate
    }
    private let calculate: UnaryCalculate
}

extension UnaryOperationDataSource: DataSource {
    func calculate(_ operands: [Decimal], with completion: (Result<Decimal, Error>) -> Void) {
        guard operands.count == 1 else { return completion(.failure(DataSourceError.invalidNumberOfOperands)) }
        return completion(.success(calculate(operands[0])))
    }
}
