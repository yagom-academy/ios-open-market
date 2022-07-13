//
//  ProductPage.swift
//  OpenMarket
//
//  Created by 웡빙, 보리사랑 on 2022/07/11.
//
import Foundation

struct ProductPage: Codable {
    let pageNo: Int
    let itemsPerPage: Int
    let totalCount: Int
    let offset: Int
    let limit: Int
    let pages: [Product]
    let lastPage: Int
    let hasNext: Bool
    let hasPrev: Bool
    
    enum CodingKeys: String, CodingKey {
        case pageNo = "page_no"
        case itemsPerPage = "items_per_page"
        case totalCount = "total_count"
        case offset
        case limit
        case pages
        case lastPage = "last_page"
        case hasNext = "has_next"
        case hasPrev = "has_prev"
    }
    
    func printPage() {
        pages.forEach {
            print("\($0.name)의 가격은 \($0.price)[\($0.currency)]입니다.")
        }
    }
}
