//
//  Request.swift
//  OpenMarket
//
//  Created by 써니쿠키, 메네 on 2022/11/16.
//

import Foundation

enum Request {
    case healthChecker
    case productList(pageNumber: Int, itemsPerPage: Int)
    case productDetail(productNumber: Int)
    case productRegistration
    
    var url: URL? {
        switch self {
        case .healthChecker:
            return URLComponents.healthCheckUrl
        case .productList(let pageNumber, let itemsPerPage):
            return URLComponents.marketUrl(path: nil,
                                           queryItems: [URLQueryItem(name: "page_no",
                                                                     value: String(pageNumber)),
                                                        URLQueryItem(name: "items_per_page",
                                                                     value: String(itemsPerPage))])
        case .productDetail(let productNumber):
            return URLComponents.marketUrl(path: [String(productNumber)], queryItems: nil)
        case .productRegistration:
            return URLComponents.marketUrl(path: nil, queryItems: nil)
        }
    }
}
