//
//  Page.swift
//  OpenMarket
//
//  Created by 오승기 on 2021/08/10.
//

import Foundation

struct Page: Codable {
    var pageNumber: Int
    var products: [Product]
    
    enum CodingKeys: String, CodingKey {
        case pageNumber = "page"
        case products = "items"
    }
}
