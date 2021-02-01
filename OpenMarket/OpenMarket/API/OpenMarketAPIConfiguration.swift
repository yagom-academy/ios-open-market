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
    
    static var sampleDataOfMarkePage: Data {
        guard let dataAsset = NSDataAsset(name: "items") else {
            print("wrong dataAsset - items")
            return Data()
        }
        return dataAsset.data
    }
    static var sampleDataOfMarkeItem: Data {
        guard let dataAsset = NSDataAsset(name: "item") else {
            print("wrong dataAsset - item")
            return Data()
        }
        return dataAsset.data
    }
    static var sampleDataOfMarketItemID: Data {
        guard let dataAsset = NSDataAsset(name: "id") else {
            print("wrong dataAsset - id")
            return Data()
        }
        return dataAsset.data
    }
}
