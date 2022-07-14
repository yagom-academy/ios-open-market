//
//  URLPath.swift
//  OpenMarket
//
//  Created by dhoney96 on 2022/07/14.
//

enum URLPath: CustomStringConvertible {
    case itemListPath(pageNumber: Int, itemsPerPage: Int)
    case productPath(productId: Int)
    
    var description: String {
        switch self {
        case let .itemListPath(pageNumber, itemsPerPage):
            return "api/products?page_no=\(pageNumber)&items_per_page=\(itemsPerPage)"
        case let .productPath(productId):
            return "api/products/\(productId)"
        }
    }
}
