//
//  NetworkError.swift
//  OpenMarket
//
//  Created by 이호영 on 2022/01/04.
//

import Foundation

enum NetworkError: LocalizedError {
    case responseCasting
    case statusCode(Int)
    case notFoundURL
    
    var errorDescription: String? {
        switch self {
        case .responseCasting:
            return "캐스팅에 실패하였습니다."
        case .statusCode(let code):
            return "상태 코드 에러 : \(code)"
        case .notFoundURL:
            return "URL을 찾을 수 없습니다."
        }
    }
}
