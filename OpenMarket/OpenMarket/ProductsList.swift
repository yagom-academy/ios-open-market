//
//  ProductsList.swift
//  OpenMarket
//
//  Created by 이정민 on 2022/11/14.
//

import Foundation

struct ProductsList: Codable {
    let pageNo: Int
    let itemsPerPage: Int
    let totalCount: Int
    let offset: Int
    let limit: Int
    let lastPage: Int
    let hasNext: Bool
    let hasPrev: Bool
    let pages: [Product]
}

