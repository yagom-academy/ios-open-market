//
//  OpenMarket - ProductList.swift
//  Created by Zhilly, Dragon. 22/11/14
//  Copyright © yagom. All rights reserved.
//

struct ProductList: Codable {
    let pageNumber: Int
    let itemsPerPage: Int
    let totalCount: Int
    let offset: Int
    let limit: Int
    let lastPage: Int
    let hasNext: Bool
    let hasPrevious: Bool
    let pages: [Product]
    
    enum CodingKeys: String, CodingKey {
        case pageNumber = "pageNo"
        case itemsPerPage
        case totalCount
        case offset
        case limit
        case lastPage
        case hasNext
        case hasPrevious = "hasPrev"
        case pages
    }
}
