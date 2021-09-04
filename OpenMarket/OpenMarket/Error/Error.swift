//
//  Error.swift
//  OpenMarket
//
//  Created by 이예원 on 2021/09/04.
//

import Foundation

enum APIError: Error {
    case invalidURL
    case emptyData
    case requestFailed
    case unknown
}
