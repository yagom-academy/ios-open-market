//
//  ItemList.swift
//  OpenMarket
//
//  Created by 스톤, 로빈 on 2022/11/15.
//
struct ItemList: Codable {
    let pageNo: Int
    let itemsPerPage: Int
    let totalCount: Int
    let offeset: Int
    let limit: Int
    let lastPage: Int
    let hasNext: Bool
    let hasPrev: Bool
    let pages: [Item]
    
    enum CodingKeys: String, CodingKey {
        case pageNo = "page_no"
        case itemsPerPage = "items_per_page"
        case totalCount = "total_count"
        case offeset ,limit ,lastPage ,hasNext ,hasPrev, pages
    }
}
