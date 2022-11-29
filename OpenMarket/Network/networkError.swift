//
//  networkError.swift
//  OpenMarket
//
//  Created by Gundy, Wonbi on 2022/11/29.
//

import Foundation

enum NetworkError: Error {
    case invalidRequest
    case requestFailed(description: String)
    case responseFailed(code: Int)
    case invaildData
    case invaildURL
    
    var errorDescription: String {
        switch self {
        case .invalidRequest:
            return "invalidRequest"
        case .requestFailed(let description):
            return description
        case .responseFailed(let code):
            return "statusCode: \(code)"
        case .invaildData:
            return "invaildData"
        case .invaildURL:
            return "invaildURL"
        }
    }
}
