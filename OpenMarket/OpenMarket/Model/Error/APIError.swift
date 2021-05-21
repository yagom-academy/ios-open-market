//
//  APIError.swift
//  OpenMarket
//
//  Created by Hailey, Ryan on 2021/05/14.
//

import Foundation

enum APIError: Error {
    case invalidURL
    case decodingFailure
    case encodingFailure
    case invalidData
    case networkFailure(Int)
    case requestFailure
    case downcastingFailure(String)
}

extension APIError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "잘못된 URL입니다🚨"
        case .decodingFailure:
            return "디코딩 실패🚨"
        case .encodingFailure:
            return "인코딩 실패🚨"
        case .invalidData:
            return "데이터를 받지 못했어요😢"
        case .networkFailure(let statusCode):
            return "\(statusCode) 서버와의 통신에 실패하였습니다🚨"
        case .requestFailure:
            return "서버에 요청하지 못했습니다🚨"
        case .downcastingFailure(let type):
            return "\(type)의 다운캐스팅에 실패하였습니다🚨"
        }
    }
}
