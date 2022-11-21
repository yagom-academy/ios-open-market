//
//  OpenMarket - URLManager.swift
//  Created by Zhilly, Dragon. 22/11/21
//  Copyright © yagom. All rights reserved.
//

import UIKit

enum URLManager {
    case healthChecker
    case productList(pageNumber: Int, itemsPerPage: Int, searchValue: String? = nil)
    case product(id: Int)
    
    var url: URL? {
        switch self {
        case .healthChecker:
            let path: String = "/healthChecker"
            return configureOpenMarketAPIURL(path: path, query: [:])
            
        case .productList(
            pageNumber: let pageNum,
            itemsPerPage: let itemPer,
            searchValue: let search
        ):
            let path: String = "/api/products?"
            var queryDictionary: [String: String] = [
                "page_no": String(pageNum),
                "items_per_page": String(itemPer)
            ]
            
            if let searchValue = search {
                queryDictionary.updateValue(searchValue, forKey: "search_value")
            }
            return configureOpenMarketAPIURL(path: path, query: queryDictionary)
    
            
        case .product(id: let id):
            let path: String = "/api/products/"
            let queryDictionary: [String: String] = ["": String(id)]
            return configureOpenMarketAPIURL(path: path, query: queryDictionary)
        }
    }
}

extension URLManager {
    private func configureOpenMarketAPIURL(path: String, query: [String: String]) -> URL? {
        let hostURL: String = "https://openmarket.yagom-academy.kr"
        var components: URLComponents? = URLComponents(string: hostURL)
        for item in query {
            let queryItem: URLQueryItem = URLQueryItem(name: item.key, value: item.value)
            components?.queryItems?.append(queryItem)
        }
        
        return components?.url
    }
}
