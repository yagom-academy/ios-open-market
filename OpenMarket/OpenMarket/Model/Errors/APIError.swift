//
//  APIError.swift
//  OpenMarket
//
//  Created by Jun Bang on 2022/01/05.
//

import Foundation

enum APIError: Error {
    case invalidResponse
    case invalidHTTPMethod
    case invalidRequest
    case noData
}
