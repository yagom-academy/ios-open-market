//
//  ParsingError.swift
//  OpenMarket
//
//  Created by JINHONG AN on 2021/08/12.
//

import Foundation

enum ParsingError: Error, LocalizedError {
    case assetDataError
    case decodingError
    
    var errorDescription: String {
        switch self {
        case .assetDataError:
            return "에셋 데이터를 불러오던 도중 문제가 발생하였습니다."
        case .decodingError:
            return "디코딩을 하는 도중 문제가 발생했습니다."
        }
    }
}
