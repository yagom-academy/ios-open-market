//
//  APINode.swift
//  OpenMarket
//
//  Created by 황인우 on 2021/05/31.
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
    var httpMethods: HTTPMethods
    
}
