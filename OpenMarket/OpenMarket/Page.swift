//
//  Page.swift
//  OpenMarket
//
//  Created by Ayaan, junho on 2022/11/14.
//

struct Page: Decodable {
    let number, productPerPage, totalCount: Int
    let offset, limit: Int
    let lastPage: Int
    let hasNextPage, hasPreviousPage: Bool
    let products: [Product]
    
    private enum CodingKeys: String, CodingKey {
        case number = "pageNo"
        case productPerPage = "itemPerPage"
        case totalCount, offset, limit, lastPage
        case hasNextPage = "hasNext"
        case hasPreviousPage = "hasPrev"
        case products = "pages"
    }
}
