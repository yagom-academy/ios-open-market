//
//  NetworkError.swift
//  OpenMarket
//
//  Created by JINHONG AN on 2021/08/13.
//

import Foundation

enum NetworkError: Error, LocalizedError {
    case invalidURL
    case unknown
    
    var errorDescription: String {
        switch self {
        case .invalidURL:
            return "유효하지 않은 URL입니다."
        case .unknown:
            return "알 수 없는 오류가 발생하였습니다."
        }
    }
}
