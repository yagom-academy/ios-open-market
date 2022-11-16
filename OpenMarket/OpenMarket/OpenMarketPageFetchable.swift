//
//  OpenMarketPageFetchable.swift
//  OpenMarket
//
//  Created by Ayaan, junho on 2022/11/16.
//

import Foundation

protocol OpenMarketPageFetchable: OpenMarketURLSessionProtocol {
    func fetchPage(pageNumber: Int,
                   productsPerPage: Int,
                   completion: @escaping (Page?) -> Void)
}

extension OpenMarketPageFetchable {
    func fetchPage(pageNumber: Int,
                   productsPerPage: Int,
                   completion: @escaping (Page?) -> Void) {
        let query: String = "api/products?page_no=\(pageNumber)&items_per_page=\(productsPerPage)"
        
        fetchOpenMarketDataTask(query: query) { (data, error) in
            if let error = error {
                print(error.localizedDescription)
                completion(nil)
            } else if let data = data {
                completion(try? JSONDecoder().decode(Page.self, from: data))
            }
        }?.resume()
    }
}
