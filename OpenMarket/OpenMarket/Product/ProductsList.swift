//
//  ProductsList.swift
//  OpenMarket
//
//  Created by Jpush, Aaron on 2022/11/14.
//

import Foundation

struct ProductsList: Codable {
    let pageNo: Int
    let itemsPerPage: Int
    let totalCount: Int
    let offset: Int
    let limit: Int
    let lastPage: Int
    let hasNext: Bool
    let hasPrev: Bool
    let products: [Product]
    
    enum CodingKeys: String, CodingKey {
        case pageNo
        case itemsPerPage
        case totalCount
        case offset
        case limit
        case lastPage
        case hasNext
        case hasPrev
        case products = "pages"
    }
}


