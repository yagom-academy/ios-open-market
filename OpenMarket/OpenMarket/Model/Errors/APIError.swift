//
//  APIError.swift
//  OpenMarket
//
//  Created by Jun Bang on 2022/01/05.
//

import Foundation

enum APIError: Error {
    case invalidResponse
    case unsuccessfulStatusCode(statusCode: Int)
    case noData
}

extension APIError {
    var description: String {
        switch self {
        case .invalidResponse:
            return "유효하지 않은 응답입니다."
        case .unsuccessfulStatusCode(let statusCode):
            return "통신에 성공하지못했습니다. 응답코드: \(statusCode)"
        case .noData:
            return "데이터가 없습니다."
        }
    }
}
