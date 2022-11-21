//
//  ItemList.swift
//  OpenMarket
//
//  Created by 스톤, 로빈 on 2022/11/15.
//
struct ItemList: Codable, Hashable {
    let pageNo, itemsPerPage, totalCount, offset: Int
    let limit, lastPage: Int
    let hasNext, hasPrev: Bool
    let pages: [Item]
}
