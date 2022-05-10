//
//  Products.swift
//  OpenMarket
//
//  Created by Red, Mino. on 2022/05/10.
//

struct Products: Codable {
    let page_no: Int
    let itemsPerPage: Int
    let totalCount: Int
    let offset: Int
    let limit: Int
    let pages: [Item]

    enum Codingkeys: String, CodingKey {
        case pageNo = "page_no"
        case itemsPerPage = "items_per_page"
        case totalCount = "total_count"
        case offset
        case limit
        case pages
    }
}
