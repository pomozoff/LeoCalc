//
//  BitcoinDataSource.swift
//  LeoCalc
//
//  Created by Anton Pomozov on 22.07.2021.
//

import Foundation
import NetworkKit

class BitcoinDataSource {
    init(
        bitcoinProvider: Provider<BitcoinAPI>,
        parsable: Parsable,
        currencyCode: String
    ) {
        self.bitcoinProvider = bitcoinProvider
        self.parsable = parsable
        self.currencyCode = currencyCode
    }

    private let bitcoinProvider: Provider<BitcoinAPI>
    private let parsable: Parsable
    private let currencyCode: String
}

extension BitcoinDataSource: DataSource {
    func calculate(_ operands: [Decimal], with completion: @escaping (Result<Decimal, Error>) -> Void) {
        guard operands.count == 1 else { return completion(.failure(DataSourceError.invalidNumberOfOperands)) }

        bitcoinProvider.request(.fetch) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case let .success(response):
                do {
                    let bitcoin: Bitcoin = try self.parsable.parse(response)
                    guard let rate = bitcoin.bpi[self.currencyCode]?.rate else {
                        return completion(.failure(DataSourceError.valueNotFound))
                    }
                    completion(.success(operands[0] * rate))
                } catch {
                    print(error)
                    completion(.failure(error))
                }
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}
