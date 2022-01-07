//
//  ShowProductPageRequest.swift
//  OpenMarket
//
//  Created by Jae-hoon Sim on 2022/01/07.
//

import Foundation

struct ShowProductPageRequest: GETRequest {
    var path: String
    
    init(pageNumber: String, itemsPerPage: String) {
        self.path = "/api/products?page_no=\(pageNumber)&items_per_page=\(itemsPerPage)"
    }
}

