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
    
    var request: (url: String, method: HttpMethod) {
        switch self {
        case .getItemCollection(let page):
            return (url: OpenMarketAPI.baseURL + "items/\(page)", method: HttpMethod.get)
        case .getItem(let id):
            return (url: OpenMarketAPI.baseURL + "item/\(id)", method: HttpMethod.get)
        case .deleteItem(let id):
            return (url: OpenMarketAPI.baseURL + "item/\(id)", method: HttpMethod.delete)
        case .patchItem(let id):
            return (url: OpenMarketAPI.baseURL + "item/\(id)", method: HttpMethod.patch)
        case .postItem:
            return (url: OpenMarketAPI.baseURL + "item", method: HttpMethod.post)
        }
    }
}
