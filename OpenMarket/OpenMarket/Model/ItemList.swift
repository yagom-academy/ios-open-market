//
//  ItemList.swift
//  OpenMarket
//
//  Created by Ash and som on 2022/11/15.
//

struct ItemList: Codable {
    let pageNo, itemsPerPage, totalCount, offset: Int
    let limit: Int
    let pages: [Item]
    let lastPage: Int
    let hasNext, hasPrev: Bool
}
