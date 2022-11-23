//
//  OpenMarketProductFetchable.swift
//  OpenMarket
//
//  Created by Ayaan, junho on 2022/11/16.
//

import Foundation

protocol OpenMarketProductFetchable: OpenMarketURLSessionProtocol {
    func fetchProduct(productNumber: Int,
                      completion: @escaping(Product?) -> Void)
}

extension OpenMarketProductFetchable {
    func fetchProduct(productNumber: Int,
                      completion: @escaping(Product?) -> Void) {
        let query: String = "api/products/\(productNumber)"
        
        fetchOpenMarketDataTask(query: query) { (data, error) in
            if let error: Error = error {
                print(error.localizedDescription)
                completion(nil)
            } else if let data: Data = data {
                completion(try? JSONDecoder().decode(Product.self, from: data))
            } else {
                completion(nil)
            }
        }?.resume()
    }
}
