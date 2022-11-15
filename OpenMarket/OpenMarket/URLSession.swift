//
//  URLSession.swift
//  OpenMarket
//
//  Created by Ayaan, junho on 2022/11/15.
//

import Foundation

extension URLSession {
    private func fetchOpenMarketAPIDataTask(query: String,
                                            completion: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        guard let hostURL = URL(string: "https://openmarket.yagom-academy.kr"),
              let url = URL(string: query, relativeTo: hostURL) else {
            fatalError()
        }
        
        return self.dataTask(with: url) { (data, response, error) in
            guard let data = data, error == nil else {
                completion(nil, response, error)
                return
            }
            completion(data, response, nil)
        }
    }
    
    func checkHealthTask(completion: @escaping (Bool) -> Void) {
        let query: String = "healthChecker"
        fetchOpenMarketAPIDataTask(query: query) { (_, response, error) in
            guard error == nil, let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                completion(false)
                return
            }
            completion(true)
        }.resume()
    }
    
    func fetchPageTask(pageNumber: Int,
                       productsPerPage: Int,
                       completion: @escaping (Page?) -> Void) {
        let query: String = "api/products?page_no=\(pageNumber)&items_per_page=\(productsPerPage)"
        fetchOpenMarketAPIDataTask(query: query) { (data, response, error) in
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode),
                  let data = data, error == nil else {
                completion(nil)
                return
            }
            completion(try? JSONDecoder().decode(Page.self, from: data))
        }.resume()
    }
    
    func fetchProductTask(productNumber: Int,
                          completion: @escaping(Product?) -> Void) {
        let query: String = "api/products/\(productNumber)"
        fetchOpenMarketAPIDataTask(query: query) { (data, response, error) in
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode),
                  let data = data, error == nil else {
                completion(nil)
                return
            }
            completion(try? JSONDecoder().decode(Product.self, from: data))
        }.resume()
    }
}
