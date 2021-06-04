//
//  MarketAPI.swift
//  OpenMarket
//
//  Created by Tak on 2021/06/01.
//

import Foundation

enum MarketAPI {
    static let baseURL = "https://camp-open-market-2.herokuapp.com/"
    case items(page: Int)
    case registrate
    case item(id: Int)
    case edit(id: Int)
    case delete(id: Int)
    
    var url: URL? {
        switch self {
        case .items(let page):
            return URL(string: MarketAPI.baseURL + "/items/" + "\(page)")
        case .registrate:
            return URL(string: MarketAPI.baseURL + "/item")
        case .item(let id):
            return URL(string: MarketAPI.baseURL + "/item/" + "\(id)")
        case .edit(let id):
            return URL(string: MarketAPI.baseURL + "/item/" + "\(id)")
        case .delete(let id):
            return URL(string: MarketAPI.baseURL + "/item/" + "\(id)")
        }
    }
}
