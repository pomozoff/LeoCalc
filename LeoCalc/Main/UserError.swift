//
//  UserError.swift
//  LeoCalc
//
//  Created by Anton Pomozov on 25.07.2021.
//

import CommonKit
import Foundation

enum UserErrorCode: Int, BaseErrorCode {
    case `internal` = 0
    case external

    var localizedDescription: String {
        switch self {
        case .internal: return "Internal error"
        case .external: return "External error"
        }
    }
}

class UserError: BaseError<UserErrorCode> {
    override var domainShortName: String { "US" }
    override var localizedFailureReason: String? {
        underlyingError?.localizedFailureReason
    }
}

extension UserError {
    var message: String {
        "\(localizedFailureReason.map { "\($0)\n" } ?? "")\n\(erroCodePrefix)\(shortErrorIdentifier)"
    }
}
