//
//  OpenMarketError.swift
//  OpenMarket
//
//  Created by Tak on 2021/06/03.
//

import Foundation

enum APIError: Error {
    case failedNetwork
    case invalidURL
    case requestProblem
    case responseProblem
    case encodingProblem
    case decodingProblem
    case unknownProblem
}

extension APIError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .failedNetwork:
            return "실패한 네트워크"
        case .invalidURL:
            return "잘못된 URL"
        case .requestProblem:
            return "서버 요청 실패"
        case .responseProblem:
            return "서버 응답 문제"
        case .encodingProblem:
            return "인코딩 실패"
        case .decodingProblem:
            return "디코딩 실패"
        case .unknownProblem:
            return "알 수 없는 문제 발생"
        }
    }
}
