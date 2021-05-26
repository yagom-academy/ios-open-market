//
//  OpenMarketError.swift
//  OpenMarket
//
//  Created by duckbok on 2021/05/18.
//

import Foundation

enum OpenMarketError: Error {
    case invalidURL
    case invalidData
    case didNotReceivedResponse
    case wrongResponse(_ statusCode: Int)
    case didNotReceivedData
    case JSONEncodingError
    case sessionError
    case bodyEncodingError
    case requestDataTypeNotMatch
    case requestGETWithData

    var name: String {
        return String(describing: self)
    }

    var description: String {
        switch self {
        case .invalidData:
            return "서버로부터 원하는 데이터가 도착하지 않았어요!"
        case .didNotReceivedResponse:
            return "서버로부터 응답이 오지 않네요.. OTL"
        case .wrongResponse(let statusCode):
            return "[Status Code: \(statusCode)] 저런! 원하는 응답이 오지 않았네요!"
        case .didNotReceivedData:
            return "서버로부터 데이터가 오지 않았어요.."
        case .sessionError:
            return "네트워크 연결이 불안정합니다."
        case .bodyEncodingError:
            return "서버에 보내려는 데이터의 형식에 문제가 있습니다!"
        default:
            return "개발자가 일을 안하네요! 🤯"
        }
    }
}
