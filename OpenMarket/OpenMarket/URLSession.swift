//
//  URLSession.swift
//  OpenMarket
//
//  Created by Ayaan, junho on 2022/11/15.
//

import Foundation

extension URLSession {
    private func fetchOpenMarketDataTask(query: String,
                                         completion: @escaping (Data?, Error?) -> Void) -> URLSessionDataTask? {
        guard let hostURL = URL(string: "https://openmarket.yagom-academy.kr"),
              let url = URL(string: query, relativeTo: hostURL) else {
            return nil
        }
        
        return self.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(nil, error)
            } else if (response as? HTTPURLResponse)?.statusCode != 200 {
                completion(nil, OpenMarketError.badStatus)
            } else if let data = data {
                completion(data, nil)
            }
        }
    }
    
    func fetchHealthTask(completion: @escaping (OpenMarketHealth) -> Void) {
        let query: String = "healthChecker"
        
        fetchOpenMarketDataTask(query: query) { (data, error) in
            if let error = error {
                print(error.localizedDescription)
                completion(.bad)
            } else if data != nil {
                completion(.ok)
            }
        }?.resume()
    }
    
    func fetchPageTask(pageNumber: Int,
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
    
    func fetchProductTask(productNumber: Int,
                          completion: @escaping(Product?) -> Void) {
        let query: String = "api/products/\(productNumber)"
        fetchOpenMarketDataTask(query: query) { (data, error) in
            if let error = error {
                print(error.localizedDescription)
                completion(nil)
            } else if let data = data {
                completion(try? JSONDecoder().decode(Product.self, from: data))
            }
        }?.resume()
    }
}
