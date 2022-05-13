//
//  NetworkError.swift
//  OpenMarket
//
//  Created by papri, Tiana on 2022/05/10.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case invalidStatusCode(error: Error?, statusCode: Int?)
    case emptyData
}

extension NetworkError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "invalidURL"
        case .invalidStatusCode(let error, let statusCode):
            return "error: \(String(describing: error)), statusCode: \(String(describing: statusCode))"
        case .emptyData:
            return "emptyData"
        }
    }
}
