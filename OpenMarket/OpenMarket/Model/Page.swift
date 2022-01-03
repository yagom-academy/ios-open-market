//
//  Page.swift
//  OpenMarket
//
//  Created by Jae-hoon Sim on 2022/01/03.
//

import Foundation

struct Page: Codable {
    let pageNumber: Int
    let itemsPerPage: Int
    let totalCount: Int
    let offset: Int
    let limit: Int
    let lastPage: Int
    let hasNext: Bool
    let hasPrev: Bool
    let pages: [Product]
}
