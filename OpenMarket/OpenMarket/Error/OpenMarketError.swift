//
//  OpenMarketError.swift
//  OpenMarket
//
//  Created by Grumpy, OneTool on 2022/05/10.
//

import Foundation

enum OpenMarketError: Error {
    case invalidData
    case missingDestination
    case invalidResponse
    case unknownError
    case failDecode
}
