//
//  ShowProductPageRequest.swift
//  OpenMarket
//
//  Created by Jae-hoon Sim on 2022/01/07.
//

import Foundation

struct ShowProductPageRequest: OpenMarketAPIRequest {
    
    var method: HTTPMethod
    var header: [String : String]?
    var path: String
    
    init(pageNumber: String, itemsPerPage: String) {
        self.method = .GET
        self.header = nil
        self.path = "/api/products?page_no=\(pageNumber)&items_per_page=\(itemsPerPage)"
    }
    
}
