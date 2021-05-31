//
//  APINode.swift
//  OpenMarket
//
//  Created by James on 2021/05/31.
//

import Foundation

struct APINode {
    var baseURL: String =
        "https://camp-open-market-2.herokuapp.com/"
    var urlForItemList: String {
        return baseURL + "items/"
    }
    var urlForSingleItem: String {
        return baseURL + "item"
    }
}
