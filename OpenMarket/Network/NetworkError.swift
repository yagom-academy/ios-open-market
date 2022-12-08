//
//  NetworkError.swift
//  OpenMarket
//
//  Created by Gundy, Wonbi on 2022/11/29.
//

import Foundation

enum NetworkError: LocalizedError {
    case invalidRequest
    case requestFailed(description: String)
    case responseFailed(code: Int)
    case invalidData
    case invalidURL
    
    var errorDescription: String? {
        switch self {
        case .invalidRequest:
            return "invalidRequest"
        case .requestFailed(let description):
            return description
        case .responseFailed(let code):
            return "statusCode: \(code)"
        case .invalidData:
            return "invalidData"
        case .invalidURL:
            return "invalidURL"
        }
    }
}
