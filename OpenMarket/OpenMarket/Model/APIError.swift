//
//  APIError.swift
//  OpenMarket
//
//  Created by Seungjin Baek on 2021/05/13.
//

import Foundation

enum APIError: Error {
    case NotFound404Error
    case JSONParseError
}

extension APIError: CustomStringConvertible {
    var description: String {
        switch self {
        case .NotFound404Error:
            return StringContainer.Error.description + StringContainer.NotFound404Error.description
        case .JSONParseError:
            return StringContainer.Error.description + StringContainer.JSONParseError.description
        }
    }
}
