//
//  OpenMarketAPIClient.swift
//  OpenMarket
//
//  Created by Kyungmin Lee on 2021/01/27.
//

import Foundation

enum OpenMarketAPI {
    case checkMarketPage
    case registerMarketItem
    case checkMarketItem
    case modifyMarketItem
    case deleteMarketItem
    
    static let baseURL = "https://camp-open-market.herokuapp.com/"
    var path: String {
        switch self {
        case .checkMarketPage:
            return "items/"
        case .registerMarketItem:
            return "item"
        case .checkMarketItem:
            return "item/"
        case .modifyMarketItem:
            return "item/"
        case .deleteMarketItem:
            return "item/"
        }
    }
    var url: URL? {
        return URL(string: OpenMarketAPI.baseURL + path)
    }
}

enum OpenMarketAPIError: LocalizedError {
    case unknownError
    var errorDescription: String? { "unknown error" }
}

class OpenMarketAPIClient {
    
}
