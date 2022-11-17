//
//  NetworkRequest.swift
//  OpenMarket
//  Created by inho, Hamo, Jeremy on 2022/11/15.
//

import Foundation

enum NetworkRequest {
    case healthCheck
    case productList
    case product
    
    var url: URL? {
        switch self {
        case .healthCheck:
            return URL(string: "https://openmarket.yagom-academy.kr/healthChecker")
        case .productList:
            return URL(string: "https://openmarket.yagom-academy.kr/api/products?page_no=1&items_per_page=100")
        case .product:
            return URL(string: "https://openmarket.yagom-academy.kr/api/products/32")
        }
    }
}
