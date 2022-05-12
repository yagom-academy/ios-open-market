//
//  NetworkError.swift
//  OpenMarket
//
//  Created by Red, Mino. on 2022/05/10.
//

import Foundation

enum NetworkError: LocalizedError {
    case unknownError
    case invalidHttpStatusCodeError(statusCode: Int)
    case urlComponetError
    case emptyDataError
    case decodeError
    case responseError

    var errorDescription: String? {
        switch self {
        case .unknownError: return "알 수 없는 에러입니다."
        case .invalidHttpStatusCodeError(let statusCode): return "status코드가 200~299가 아닌, \(statusCode)입니다."
        case .urlComponetError: return "URL components 생성 에러가 발생했습니다."
        case .emptyDataError: return "data가 비어있습니다."
        case .decodeError: return "decode 에러가 발생했습니다."
        case .responseError: return "response 수신을 실폐 했습니다."
        }
    }
}
