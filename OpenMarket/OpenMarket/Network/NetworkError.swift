//  NetworkError.swift
//  OpenMarket
//  Created by SummerCat & Bella on 2022/11/18.

import Foundation

enum NetworkError: String, Error {
    case statusCodeError
    case noData
    case URLError
    case decodingError
    
    var description: String {
        switch self {
        case .statusCodeError:
            return "http 응답 에러"
        case .noData:
            return "데이터 없음"
        case .URLError:
            return "URL 오류"
        case .decodingError:
            return "디코딩 오류"
        }
    }
}
