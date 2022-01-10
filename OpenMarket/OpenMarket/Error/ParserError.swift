//
//  ParserError.swift
//  OpenMarket
//
//  Created by Ari on 2022/01/03.
//

import Foundation

enum ParserError: LocalizedError {
    case assetNotfound
    case decodingFail
    case encodingFail
    
    var errorDescription: String? {
        switch self {
        case .assetNotfound:
            return "에셋 데이터를 찾을 수 없습니다."
        case .decodingFail:
            return "디코딩을 하는 도중 에러가 발생했습니다."
        case .encodingFail:
            return "인코딩을 하는 도중 에러가 발생했습니다."
        }
    }
}
