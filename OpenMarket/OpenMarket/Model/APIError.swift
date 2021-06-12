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
            return StringContainer.Error.description + StringContainer.NotFound404Error.description
        case .JSONParseError:
            return StringContainer.Error.description + StringContainer.JSONParseError.description
        case .InvalidAddressError:
            return StringContainer.Error.description + StringContainer.InvalidAddressError.description
        case .NetworkFailure:
            return StringContainer.Error.description + StringContainer.NetworkFailure.description
        }
    }
}
