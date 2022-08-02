//
//  NetworkError.swift
//  OpenMarket
//
//  Created by unchain, hyeon2 on 2022/07/12.
//

enum NetworkError: Error {
    case outOfRange
    case failToDecoding
    case failToEncoding
    case noneData
    
    var message: String {
        switch self {
        case .outOfRange:
            return "요청하신 작업을 수행할 수 없습니다."
        case .failToDecoding:
            return "디코딩을 할 수 없습니다."
        case .failToEncoding:
            return "인코딩을 할 수 없습니다."
        case .noneData:
            return "데이터가 없습니다."
        }
    }
}
