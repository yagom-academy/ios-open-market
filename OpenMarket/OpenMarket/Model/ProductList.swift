//
//  ProductList.swift
//  OpenMarket
//
//  Created by marlang, Taeangel on 2022/05/10.
//

import Foundation

struct ProductList: Decodable {
    let pageno: Int?
    let itemsPerPage: Int?
    let totalCount: Int?
    let offset: Int?
    let limit: Int?
    let pages: [Product]?
    let lastPage: Int?
    let hasNextPage: Bool?
    let hasPrevPage: Bool?
}
