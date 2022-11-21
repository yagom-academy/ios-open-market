//
//  OpenMarketAPI.swift
//  OpenMarket
//
//  Copyright (c) 2022 Minii All rights reserved.

import Foundation

enum OpenMarketAPI: APIType {
    case healthChecker
    case productsList(pageNumber: Int, rowCount: Int, searchValue: String = "")
    case productSearch(productId: Int)
    
    var baseURL: String {
        return "https://openmarket.yagom-academy.kr"
    }
    
    var path: String {
        switch self {
        case .healthChecker:
            return "/healthChecker"
        case .productsList(_, _, _):
            return "/api/products"
        case .productSearch(let productId):
            return "/api/products/\(productId)"
        }
    }
    
    var parameters: [String : String] {
        switch self {
        case .productsList(let pageNumber, let rowCount, let searchValue):
            return [
                "page_no": pageNumber.description,
                "items_per_page": rowCount.description,
                "search_value": searchValue
            ]
        default:
            return [:]
        }
    }
    
    func generateURL() -> URL? {
        guard var baseComponents = URLComponents(string: baseURL) else {
            return nil
        }
        
        baseComponents.path = path
        baseComponents.queryItems = parameters.asParameters()
        
        return baseComponents.url
    }
}
