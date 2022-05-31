//
//  NetworkError.swift
//  OpenMarket
//
//  Created by marlang, Taeangel on 2022/05/12.
//

import Foundation

enum NetworkError: Error {
    case unknownError
    case statusCodeError
    case decodeError
    case urlError
    case clientError
    case dataError
    case imageError
}

extension NetworkError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .unknownError:
            return "unknownError"
        case .statusCodeError:
            return "statusCodeError"
        case .decodeError:
            return "decodeError"
        case .urlError:
            return "urlError"
        case .clientError:
            return "clientError"
        case .dataError:
            return "dataError"
        case .imageError:
            return "imageError"

        }
    }
}
