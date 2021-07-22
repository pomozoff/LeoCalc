//
//  BitcoinAPI.swift
//  LeoCalc
//
//  Created by Anton Pomozov on 22.07.2021.
//

import Foundation
import NetworkKit

enum BitcoinAPI {
    case fetch
}

extension BitcoinAPI: Target {
    var baseURL: String { "https://api.coindesk.com" }

    var path: String { "/v1/bpi/currentprice.json" }

    var method: NetworkKit.Method { .get }

    var headers: [String : String]? { nil }

    var task: NetworkKit.Task { .requestPlain }
}
