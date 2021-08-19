//
//  OpenMarketAPI.swift
//  OpenMarket
//
//  Created by Luyan, Ellen on 2021/08/17.
//

import Foundation

enum OpenMarketAPI {
    static let baseURL = "https://camp-open-market-2.herokuapp.com/"
    
    case getItemCollection(page: Int)
    case getItem(id: Int)
    case deleteItem(id: Int)
    case patchItem(id: Int)
    case postItem
    
    var urlInfo: (url: String, type: HttpMethod) {
        switch self {
        case .getItem(let id):
            return (url: OpenMarketAPI.baseURL + "item/\(id)", type: HttpMethod.get)
        case .getItemCollection(let page):
            return (url: OpenMarketAPI.baseURL + "items/\(page)", type: HttpMethod.get)
        case .deleteItem(let id):
            return (url: OpenMarketAPI.baseURL + "item/\(id)", type: HttpMethod.delete)
        case .patchItem(let id):
            return (url: OpenMarketAPI.baseURL + "item/\(id)", type: HttpMethod.patch)
        case .postItem:
            return (url: OpenMarketAPI.baseURL + "item", type: HttpMethod.post)
        }
    }
}
