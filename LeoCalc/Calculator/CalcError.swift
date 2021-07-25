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

    var localizedDescription: String {
        switch self {
        case .nan: return "Not a number"
        }
    }
}

class CalcError: BaseError<CalcErrorCode> {
    override var domainShortName: String { "CA" }
    override var localizedFailureReason: String? { errorCode.localizedDescription }
}
