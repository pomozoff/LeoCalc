//
//  BitcoinDataSource.swift
//  LeoCalc
//
//  Created by Anton Pomozov on 22.07.2021.
//

import Foundation
import NetworkKit

class BitcoinDataSource {
    init(bitcoinProvider: Provider<BitcoinAPI>, parsable: Parsable) {
        self.bitcoinProvider = bitcoinProvider
        self.parsable = parsable
    }

    private let bitcoinProvider: Provider<BitcoinAPI>
    private let parsable: Parsable
}

extension BitcoinDataSource: DataSource {
    func calculate(operands: [Decimal], completion: @escaping (Result<Decimal, Error>) -> Void) {
        bitcoinProvider.request(.fetch) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case let .success(response):
                do {
                    let bitcoin: Bitcoin = try self.parsable.parse(response)
                    completion(.success(bitcoin.value))
                } catch {
                    completion(.failure(error))
                }
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}
