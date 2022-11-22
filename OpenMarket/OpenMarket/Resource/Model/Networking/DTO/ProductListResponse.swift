//
//  ProductListResponse.swift
//  OpenMarket
//
//  Created by Baemini on 2022/11/14.
//

struct ProductListResponse: Decodable {
    let numberOfPage, itemCountInPage, totalCount, offset, limit, endOfPage: Int
    let products: [Product]
    let hasNextPage, hasPrevPage: Bool
    
    enum CodingKeys: String, CodingKey {
        case offset, limit
        case numberOfPage = "pageNo"
        case itemCountInPage = "itemsPerPage"
        case totalCount = "totalCount"
        case products = "pages"
        case endOfPage = "lastPage"
        case hasNextPage = "hasNext"
        case hasPrevPage = "hasPrev"
    }
}
