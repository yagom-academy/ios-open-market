//
//  OpenMarketError.swift
//  OpenMarket
//
//  Created by Ari on 2022/01/11.
//

import Foundation

enum OpenMarketError: LocalizedError {
    case badRequestURL
    
    var errorDescription: String? {
        switch self {
        case .badRequestURL:
            return "이미지의 URL이 잘못된 형식의 URL입니다."
        }
    }
}
