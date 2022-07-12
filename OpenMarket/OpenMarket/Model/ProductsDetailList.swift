//
//  Product.swift
//  OpenMarket
//
//  Created by NAMU on 2022/07/12.
//

struct ProductsDetailList: Decodable {
    private(set) var pageNumber: Int
    private(set) var itemsPerPage: Int
    private(set) var totalCount: Int
    private(set) var offset: Int
    private(set) var limit: Int
    private(set) var pages: [ProductDetail]

    
    enum CodingKeys: String, CodingKey {
        case pageNumber = "page_no"
        case itemsPerPage = "items_per_page"
        case totalCount = "total_count"
        case offset
        case limit
        case pages
    }
}
