//
//  OpenMarketAPIConfiguration.swift
//  OpenMarket
//
//  Created by Kyungmin Lee on 2021/01/30.
//

import UIKit

enum OpenMarketAPIConfiguration {
    case getMarketPage(pageNumber: Int)
    case postMarketItem
    case getMarketItem(id: Int)
    case patchMarketItem(id: Int)
    case deleteMarketItem(id: Int)
    
    static let baseURL = "https://camp-open-market.herokuapp.com/"
    var path: String {
        switch self {
        case .getMarketPage(let pageNumber):
            return "items/\(pageNumber)"
        case .postMarketItem:
            return "item"
        case .getMarketItem(let id), .patchMarketItem(let id), .deleteMarketItem(let id):
            return "item/\(id)"
        }
    }
    var url: URL? {
        return URL(string: OpenMarketAPIConfiguration.baseURL + path)
    }
    
    static let sampleDataOfMarkePage = NSDataAsset(name: "items")!.data
    static let sampleDataOfMarkeItem = NSDataAsset(name: "item")!.data
    static let sampleDataOfMarketItemID = NSDataAsset(name: "id")!.data
}
