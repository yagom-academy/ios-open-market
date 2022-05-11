//
//  NetworkError.swift
//  OpenMarket
//
//  Created by Red, Mino. on 2022/05/10.
//

import Foundation

enum NetworkError: LocalizedError {
    case unknownError
    case invalidHttpStatusCode(statusCode: Int)
    case urlComponet
    case emptyData
    case decodeError

    var errorDescription: String? {
        switch self {
        case .unknownError: return "알 수 없는 에러입니다."
        case .invalidHttpStatusCode(let statusCode): return "status코드가 200~299가 아닌, \(statusCode)입니다."
        case .urlComponet: return "URL components 생성 에러가 발생했습니다."
        case .emptyData: return "data가 비어있습니다."
        case .decodeError: return "decode 에러가 발생했습니다."
        }
    }
}
