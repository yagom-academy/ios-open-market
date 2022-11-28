//
//  ProductList.swift
//  OpenMarket
//  Created by inho, Hamo, Jeremy on 2022/11/15.
//

import Foundation

struct ProductListData: Decodable {
    let pageNumber: Int
    let itemsPerPage: Int
    let totalCount: Int
    let offset: Int
    let limit: Int
    var pages: [ProductData]
    let lastPage: Int
    let hasNext: Bool
    let hasPrevious: Bool
    
    private enum CodingKeys: String, CodingKey {
        case pageNumber = "pageNo"
        case itemsPerPage = "itemsPerPage"
        case totalCount = "totalCount"
        case offset
        case limit
        case pages
        case lastPage = "lastPage"
        case hasNext = "hasNext"
        case hasPrevious = "hasPrev"
    }
}
