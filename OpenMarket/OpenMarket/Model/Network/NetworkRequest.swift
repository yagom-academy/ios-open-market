//
//  NetworkRequest.swift
//  OpenMarket
//  Created by inho, Hamo, Jeremy on 2022/11/15.
//

import Foundation

enum NetworkRequest {
    case healthCheck
    case productList(pageNumber: Int, itemsPerPage: Int)
    case product(identifier: Int)
    
    var url: URL? {
        switch self {
        case .healthCheck:
            return URL(string: "https://openmarket.yagom-academy.kr/healthChecker")
        case .productList(let pageNumber, let itemsPerPage):
            return URL(string: "https://openmarket.yagom-academy.kr/api/products?page_no=\(pageNumber)&items_per_page=\(itemsPerPage)")
        case .product(let identifier):
            return URL(string: "https://openmarket.yagom-academy.kr/api/products/\(identifier)")
        }
    }
}
