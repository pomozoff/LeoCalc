//
//  Parser.swift
//  LeoCalc
//
//  Created by Anton Pomozov on 22.07.2021.
//

import Foundation
import NetworkKit

protocol Parsable {
    func parse<T>(_ response: Response) throws -> T where T: Decodable
}

class Parser {}

extension Parser: Parsable {
    func parse<T>(_ response: Response) throws -> T where T: Decodable {
        switch response.statusCode {
        case 200 ..< 300:
            return try JSONDecoder().decode(T.self, from: response.data)

        case 401:
            throw NetworkError.authRequired

        case 403:
            throw NetworkError.accessDenied

        case 400 ..< 500:
            throw NetworkError.invalidRequest

        default:
            throw NetworkError.internalError
        }
    }
}
