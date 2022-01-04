//
//  ParserError.swift
//  OpenMarket
//
//  Created by Ari on 2022/01/03.
//

import Foundation

enum ParserError: LocalizedError {
    case assestNotfound
    case decoding
    case encoding
    
    var errorDescription: String {
        switch self {
        case .assestNotfound:
            return "에셋 데이터를 찾을 수 없습니다."
        case .decoding:
            return "디코딩을 하는 도중 에러가 발생했습니다."
        case .encoding:
            return "인코딩을 하는 도중 에러가 발생했습니다."
        }
    }
}
