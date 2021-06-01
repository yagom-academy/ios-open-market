//
//  APINode.swift
//  OpenMarket
//
//  Created by James on 2021/05/31.
//

import Foundation

enum OpenMarketAPI {
    case connection
    static let baseURL: String = "https://camp-open-market-2.herokuapp.com/"
    var pathForItemList: String {
        "items/"
    }
    var pathForSingleItem: String {
        "item"
    }
    
    var urlForItemList: String {
        return OpenMarketAPI.baseURL + pathForItemList
    }
    var urlForSingleItem: String {
        return OpenMarketAPI.baseURL + pathForSingleItem
    }
}
