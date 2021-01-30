//
//  OpenMarketAPIError.swift
//  OpenMarket
//
//  Created by Kyungmin Lee on 2021/01/30.
//

import Foundation

enum OpenMarketAPIError: Error {
    case invalidURL
    case requestFailed
    case networkError
}
