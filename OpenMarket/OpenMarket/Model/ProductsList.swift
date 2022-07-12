//
//  ProductList.swift
//  OpenMarket
//
//  Created by 김동용 on 2022/07/12.
//

struct ProductsList: Decodable {
    let pageNumber: Int
    let itemsPerPage: Int
    let totalCount: Int
    let offset: Int
    let limit: Int
    let lastPage: Int
    let hasNext: Bool
    let hasPrevious: Bool
    let pages: [ProductDetail]
    
    private enum CodingKeys: String, CodingKey {
        case pageNumber = "page_no"
        case itemsPerPage = "items_per_page"
        case totalCount = "total_count"
        case offset
        case limit
        case lastPage = "last_page"
        case hasNext = "has_next"
        case hasPrevious = "has_prev"
        case pages
    }
}
