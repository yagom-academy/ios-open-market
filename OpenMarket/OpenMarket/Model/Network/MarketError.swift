//
//  MarketError.swift
//  OpenMarket
//
//  Created by 윤재웅 on 2021/05/19.
//

import Foundation

enum MarketError: Error {
    case request
    case response
    case data
    case codable
    case unknown
    
    var description: String {
        switch self {
        case .request:
            return "⛔️ 요청 오류"
        case .response:
            return "⛔️ 응답 오류"
        case .data:
            return "⛔️ 데이터 오류"
        case .codable:
            return "⛔️ 파싱 오류"
        case .unknown:
            return "⛔️ 알 수 없는 오류"
        }
    }
}
