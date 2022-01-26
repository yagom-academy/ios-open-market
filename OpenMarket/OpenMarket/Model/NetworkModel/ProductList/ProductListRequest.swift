//
//  ProductListRequest.swift
//  OpenMarket
//
//  Created by 서녕 on 2022/01/09.
//

import Foundation

struct ProductListRequest: Codable {
    let pageNumber: Int
    let itemsPerPage: Int
    
    private enum CodingKeys: String, CodingKey {
        case pageNumber = "page_no"
        case itemsPerPage = "items_per_page"
    }
}
