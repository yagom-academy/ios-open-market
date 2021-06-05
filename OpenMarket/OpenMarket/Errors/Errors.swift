//
//  Errors.swift
//  OpenMarket
//
//  Created by 김민성 on 2021/06/06.
//

import Foundation

enum OpenMarketErrors: LocalizedError {
    case unkownError
    case responseError(Int)
    
    var errorDescription: String? {
        switch self {
        case .unkownError:
            return "unknownError"
        case .responseError(let code):
            return "\(code)Error1"
        }
    }
}
