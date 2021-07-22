//
//  Currency.swift
//  LeoCalc
//
//  Created by Anton Pomozov on 22.07.2021.
//

import Foundation

struct Currency {
    let code: String
    let rate: Decimal
}

extension Currency: Decodable {}

private extension Currency {
    enum CodingKeys: String, CodingKey {
        case code
        case rate = "rate_float"
    }
}
