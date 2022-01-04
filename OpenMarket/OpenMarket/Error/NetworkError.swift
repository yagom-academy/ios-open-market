//
//  NetworkError.swift
//  OpenMarket
//
//  Created by 이호영 on 2022/01/04.
//

import Foundation

enum NetworkError: Error {
    case responseCasting
    case statusCode
    case notFoundURL
}
