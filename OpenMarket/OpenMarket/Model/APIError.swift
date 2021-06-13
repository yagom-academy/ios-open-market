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
            return ErrorMessage.Error.description + ErrorMessage.NotFound404Error.description
        case .JSONParseError:
            return ErrorMessage.Error.description + ErrorMessage.JSONParseError.description
        case .InvalidAddressError:
            return ErrorMessage.Error.description + ErrorMessage.InvalidAddressError.description
        case .NetworkFailure:
            return ErrorMessage.Error.description + ErrorMessage.NetworkFailure.description
        }
    }
}
