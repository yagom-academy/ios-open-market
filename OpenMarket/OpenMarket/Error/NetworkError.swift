//
//  NetworkError.swift
//  OpenMarket
//
//  Created by tae hoon park on 2021/09/02.
//

import Foundation

enum NetworkError: Error, LocalizedError {
    case invalidURL
    case responseFailed
    case invalidHttpMethod
    case requestFailed
    case dataTaskError
    case dataNotfound
    
    var errorDescription: String {
        switch self {
        case .invalidURL:
            return "잘못된 URL입니다."
        case .responseFailed:
            return "200에서 299 상태코드를 받는데 실패했습니다."
        case .invalidHttpMethod:
            return "잘못된 HTTPMethod입니다."
        case .requestFailed:
            return "리퀘스트를 받는데 실패했습니다."
        case .dataTaskError:
            return "dataTask 전달 중 에러가 발생했습니다."
        case .dataNotfound:
            return "data를 전달 받지 못했습니다."
        }
    }
}
