//
//  NetworkRequest.swift
//  OpenMarket
//  Created by inho, Hamo, Jeremy on 2022/11/15.
//

import Foundation

enum NetworkRequest {
    case healthCheck
    case productList(pageNumber: Int, itemsPerPage: Int, searchValue: String? = nil)
    case product(identifier: Int)
    case postProduct
    
    var url: URL? {
        switch self {
        case .healthCheck:
            return configureURL(path: "/healthChecker")
        case .productList(let pageNumber, let itemsPerPage, let value):
            var names = ["page_no", "items_per_page"]
            var values = [pageNumber, itemsPerPage].map { String($0) }
            
            if let value = value {
                names.append("search_value")
                values.append(value)
            }
            return configureURL(path: "/api/products", queryNames: names, queryValues: values)
        case .product(let identifier):
            return configureURL(path: "/api/products/\(identifier)")
        case .postProduct:
            return configureURL(path: "/api/products")
        }
    }
}

extension NetworkRequest {
    func configureURL(path: String,
                      queryNames: [String]? = nil,
                      queryValues: [String]? = nil) -> URL? {
        var baseURL = URLComponents(string: "https://openmarket.yagom-academy.kr")
        var queries: [URLQueryItem] = []
        baseURL?.path.append(path)
        
        guard let names = queryNames,
              let values = queryValues
        else {
            return baseURL?.url
        }
        
        for (name, value) in zip(names, values) {
            let query = URLQueryItem(name: name, value: value)
            queries.append(query)
        }
        
        baseURL?.queryItems = queries
        return baseURL?.url
    }
}
