//
//  CalcError.swift
//  LeoCalc
//
//  Created by Anton Pomozov on 25.07.2021.
//

import CommonKit
import Foundation

enum CalcErrorCode: Int, BaseErrorCode {
    case nan = 0
    case `internal`

    var localizedDescription: String {
        switch self {
        case .nan: return "Not a number"
        case .internal: return "Internal error"
        }
    }
}

class CalcError: BaseError<CalcErrorCode> {
    override var domainShortName: String { "CA" }
    override var localizedFailureReason: String? {
        switch errorCode {
        case .nan: return errorCode.localizedDescription
        case .internal: return underlyingError?.localizedDescription
        }
    }
}
