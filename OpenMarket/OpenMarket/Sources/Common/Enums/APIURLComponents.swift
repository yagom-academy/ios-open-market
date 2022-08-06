//
//  APIURLComponents.swift
//  OpenMarket
//
//  Created by minsson, yeton on 2022/07/19.
//

import Foundation

enum APIURLComponents {
    
    // MARK: - Static Properties
    
    static var openMarketURLComponents = URLComponents(string: "https://market-training.yagom-academy.kr/api/products")
    
    // MARK: - Static Actions
    
    static func configureQueryItem(pageNumber: Int, itemsPerPage: Int) {
        openMarketURLComponents?.queryItems = [
            "page_no": "\(pageNumber)",
            "items_per_page": "\(itemsPerPage)"
        ].map { URLQueryItem(name: $0.key, value: $0.value) }
    }
}
