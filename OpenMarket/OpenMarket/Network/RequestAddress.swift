//
//  RequestAddress.swift
//  OpenMarket
//
//  Created by steven on 2021/05/19.
//

import Foundation

enum RequestAddress {
    static let BaseURL = "https://camp-open-market-2.herokuapp.com/"
    static let items = "items/"
    static let item = "item/"
    
    case readList(page: Int)
    case readItem(id: Int)
    case createItem
    case updateItem(id: Int)
    case deleteItem(id: Int)
    
    var url: String {
        switch self {
        case .readList(let page):
            return RequestAddress.BaseURL + RequestAddress.items + String(page)
        case .readItem(let id):
            return RequestAddress.BaseURL + RequestAddress.item + String(id)
        case .createItem:
            return RequestAddress.BaseURL + RequestAddress.item
        case .updateItem(let id):
            return RequestAddress.BaseURL + RequestAddress.item + String(id)
        case .deleteItem(let id):
            return RequestAddress.BaseURL + RequestAddress.item + String(id)
        }
    }
}
