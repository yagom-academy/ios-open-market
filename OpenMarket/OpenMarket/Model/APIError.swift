//
//  APIError.swift
//  OpenMarket
//
//  Created by Seungjin Baek on 2021/05/13.
//

import Foundation

enum APIError: LocalizedError {
    case NotFound404Error
    case JSONParseError
    case InvalidAddressError
    case NetworkFailure
}

extension APIError {
    var errorDescription: String? {
        switch self {
        case .NotFound404Error:
            return "[Error] Cannot find data"
        case .JSONParseError:
            return "[Error] Cannot parse JSONData"
        case .InvalidAddressError:
            return "[Error] Invalid URL"
        case .NetworkFailure:
            return "[Error] Network Failure"
        }
    }
}
