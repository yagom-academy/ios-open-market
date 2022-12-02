//
//  APIError.swift.swift
//  OpenMarket
//
//  Created by Mangdi, Woong on 2022/11/15.
//

enum APIError: String, Error {
    case wrongUrlError = "잘못된 URL 오류"
    case unkownError = "알수없는 오류"
    case statusCodeError = "상태 코드 오류"
    case jsonDecodingError = "json 디코딩 오류"
    case imageDataConvertError = "이미지 데이터 변환 오류"
}
