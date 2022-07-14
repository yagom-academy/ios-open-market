//
//  ProductListResponse.swift
//  OpenMarket
//
//  Created by BaekGom, Brad on 2022/07/11.
//

struct ProductListResponse: Decodable {
    let pageNo: Int
    let itemsPerPage: Int
    let totalCount: Int
    let offset: Int
    let limit: Int
    let pages: [Product]
}

extension ProductListResponse {
    enum CodingKeys: String, CodingKey {
        case pageNo = "page_no"
        case itemsPerPage = "items_per_page"
        case totalCount = "total_count"
        case offset
        case limit
        case pages
    }
}
