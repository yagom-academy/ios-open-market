//
//  NetworkError.swift
//  OpenMarket
//
//  Copyright (c) 2022 Minii All rights reserved.

import Foundation

enum NetworkError: Error {
    case invalidURL
    case requestError(error: Error)
    case invalidStatusCode
    case decodeError
    
    var title: String {
        return "네트워크 요청 실패"
    }
    
    var message: String {
        return "네트워크 요청에 실패하였습니다. 잠시후 다시 시도해주세요."
    }
}
