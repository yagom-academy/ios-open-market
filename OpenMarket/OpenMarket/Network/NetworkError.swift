//
//  NetworkError.swift
//  OpenMarket
//
//  Created by steven on 2021/05/24.
//

import Foundation

enum NetworkError: LocalizedError {
    case requestError
    case urlError
    case unknownError
    
    var errorDescription: String? {
        switch self {
        case .requestError:
            return "requestError"
        case .urlError:
            return "urlError"
        case .unknownError:
            return "unknownError"
        }
    }
}
