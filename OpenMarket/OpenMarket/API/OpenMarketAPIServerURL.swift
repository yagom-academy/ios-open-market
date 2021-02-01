//
//  OpenMarketAPIConfiguration.swift
//  OpenMarket
//
//  Created by Kyungmin Lee on 2021/01/30.
//

import UIKit

enum OpenMarketAPIServerURL {
    case getMarketPage(pageNumber: Int)
    case postMarketItem
    case getMarketItem(id: Int)
    case patchMarketItem(id: Int)
    case deleteMarketItem(id: Int)
    
    static let baseURL = "https://camp-open-market.herokuapp.com/"
    private var path: String {
        switch self {
        case .getMarketPage(let pageNumber):
            return "items/\(pageNumber)"
        case .postMarketItem:
            return "item"
        case .getMarketItem(let id), .patchMarketItem(let id), .deleteMarketItem(let id):
            return "item/\(id)"
        }
    }
    var fullPath: URL? {
        return URL(string: OpenMarketAPIServerURL.baseURL + path)
    }
}
