//
//  ProductPage.swift
//  OpenMarket
//
//  Created by Kyo, LJ on 2022/11/14.
//

struct ProductPage: Decodable {
    let pageNumber: Int
    let itemsPerPage: Int
    let totalCount: Int
    let offset: Int
    let limit: Int
    let pages: [Product]
    let lastPage: Int
    let hasNext: Bool
    let hasPrev: Bool
    
    private enum CodingKeys: String, CodingKey {
        case pageNumber = "pageNo"
        case itemsPerPage
        case totalCount
        case offset
        case limit
        case lastPage
        case hasNext
        case hasPrev
        case pages
    }
}
