//
//  OpenMarketError.swift
//  OpenMarket
//
//  Created by Yeon on 2021/01/26.
//

import Foundation

enum OpenMarketError: Error {
    case failFetchData
    case failUploadData
    case failDeleteData
    case failTransportData
    case failMatchMimeType
    case failGetData
    case failDecode
    case failEncode
    case failSetUpURL
    case imageFileOverSize
    case imageFileOverRegistered
    case passwordNotMatched
    case unknown
}

extension OpenMarketError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .failFetchData:
            return "서버로부터 데이터를 가져오는데 실패하였습니다."
        case .failUploadData:
            return "서버로 데이터를 올리는데 실패하였습니다."
        case .failDeleteData:
            return "서버에서 데이터를 지우는데 실패하였습니다."
        case .failTransportData:
            return "클라이언트에서 데이터를 보내는데 실패하였습니다."
        case .failMatchMimeType:
            return "데이터의 타입이 일치하지 않습니다."
        case .failGetData:
            return "데이터를 가져오는데 실패하였습니다."
        case .failDecode:
            return "데이터를 디코딩하는데 실패하였습니다."
        case .failEncode:
            return "데이터를 인코딩하는데 실패하였습니다."
        case .failSetUpURL:
            return "URL을 가져오는데 실패하였습니다."
        case .imageFileOverSize:
            return "이미지 파일의 사이즈가 제한 사이즈보다 큽니다."
        case .imageFileOverRegistered:
            return "이미지 파일의 개수가 제한 개수보다 많습니다."
        case .passwordNotMatched:
            return "비밀번호가 일치하지 않습니다."
        case .unknown:
            return "알 수 없는 오류가 발생하였습니다."
        }
    }
}
