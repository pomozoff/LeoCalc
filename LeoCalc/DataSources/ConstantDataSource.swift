//
//  ConstantDataSource.swift
//  LeoCalc
//
//  Created by Anton Pomozov on 22.07.2021.
//

import Foundation

class ConstantDataSource {
    init(value: Decimal) {
        self.value = value
    }
    private let value: Decimal
}

extension ConstantDataSource: DataSource {
    func calculate(_ operands: [Decimal], with completion: (Result<Decimal, Error>) -> Void) {
        completion(.success(value))
    }
}
