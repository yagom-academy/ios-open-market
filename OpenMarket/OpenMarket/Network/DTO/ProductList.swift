//
//  ProductList.swift
//  OpenMarket
//
//  Created by Gundy, Wonbi on 2022/11/15.
//

import Foundation

struct ProductList: Codable {
    let pageNo: Int
    let itemsPerPage: Int
    let totalCount: Int
    let offset: Int
    let limit: Int
    let pages: [Product]
    let lastPage: Int
    let hasNext: Bool
    let hasPrev: Bool
}
