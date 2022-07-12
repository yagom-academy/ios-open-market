//
//  ProductList.swift
//  OpenMarket
//
//  Created by 김동용 on 2022/07/12.
//

struct ProductList: Decodable {
    private(set) var pageNumber: Int
    private(set) var itemsPerPage: Int
    private(set) var totalCount: Int
    private(set) var offset: Int
    private(set) var limit: Int
    private(set) var lastPage: Int
    private(set) var hasNext: Bool
    private(set) var hasPrevious: Bool
    private(set) var pages: [ProductDetail]
    
    enum CodingKeys: String, CodingKey {
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
