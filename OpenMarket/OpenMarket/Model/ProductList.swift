//  ProductList.swift
//  OpenMarket
//  Created by SummerCat & Bella on 2022/11/15.

import Foundation

struct ProductList: Decodable {
    let pageNumber: Int
    let itemsPerPage: Int
    let totalCount: Int
    let firstIndex: Int
    let lastIndex: Int
    let lastPage: Int
    let hasNext: Bool
    let hasPrev: Bool
    let products: [Product]
    
    enum CodingKeys: String, CodingKey {
        case pageNumber = "pageNo"
        case itemsPerPage
        case totalCount
        case firstIndex = "offset"
        case lastIndex = "limit"
        case lastPage
        case hasNext
        case hasPrev
        case products = "pages"
    }
}
