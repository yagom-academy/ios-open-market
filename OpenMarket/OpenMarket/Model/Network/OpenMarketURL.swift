//
//  OpenMarketURL.swift
//  OpenMarket
//
//  Created by Hailey, Ryan on 2021/05/13.
//

import Foundation

enum OpenMarketURL {
    static let base: String = "https://camp-open-market-2.herokuapp.com"
    static let itemListInfix: String = "/items/"
    static let itemDetailInfix: String = "/item/"
    case viewItemList(Int)
    case registerItem
    case viewItemDetail(Int)
    case editItem(Int)
    case deleteItem(Int)
    
    var url: URL? {
        switch self {
        case .viewItemList(let page):
            return URL(string: "\(OpenMarketURL.base + OpenMarketURL.itemListInfix)\(page)")
        case .registerItem:
            return URL(string: "\(OpenMarketURL.base + OpenMarketURL.itemDetailInfix)")
        case .viewItemDetail(let id), .editItem(let id), .deleteItem(let id):
            return URL(string: "\(OpenMarketURL.base + OpenMarketURL.itemDetailInfix)\(id)")
        }
    }
}
