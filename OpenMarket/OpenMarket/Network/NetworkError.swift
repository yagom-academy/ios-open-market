//
//  NetworkError.swift
//  OpenMarket
//
//  Created by 박태현 on 2021/08/31.
//

import Foundation

enum NetworkError: Error {
    case invaildURL
    case invalidRequest
    case invalidResponse
    case invalidData
}
