//
//  MarketError.swift
//  OpenMarket
//
//  Created by 윤재웅 on 2021/05/19.
//

import Foundation

enum MarketError: Error {
    case request, response
    case url, data, encoding, decoding
    case get, post, patch, delete
    case unknown
}

extension MarketError: LocalizedError {
    var description: String {
        switch self {
        case .request:
            return "⛔️ 요청 오류"
        case .response:
            return "⛔️ 응답 오류"
        case .data:
            return "⛔️ 데이터 오류"
        case .encoding:
            return "⛔️ 인코딩 오류"
        case .decoding:
            return "⛔️ 디코딩 오류"
        case .get:
            return "⛔️ \"GET\" 메소드 오류"
        case .post:
            return "⛔️ \"POST\" 메소드 오류"
        case .patch:
            return "⛔️ \"PATCH\" 메소드 오류"
        case .delete:
            return "⛔️ \"DELECT\" 메소드 오류"
        case .url:
            return "⛔️ URL 오류"
        case .unknown:
            return "⛔️ 알 수 없는 오류"
        }
    }
}
