//
//  APIService.swift
//  OpenMarket
//
//  Created by 조민호 on 2022/05/10.
//

import Foundation

typealias DataTaskCompletionHandler = (Data?, URLResponse?, Error?) -> Void

protocol URLSessionProtocol {
    func dataTask(with url: URL,  completionHandler: @escaping DataTaskCompletionHandler) -> URLSessionDataTask
}

extension URLSession: URLSessionProtocol { }

final class APIService {
    let urlSession: URLSessionProtocol
    
    init(urlSession: URLSessionProtocol = URLSession.shared) {
        self.urlSession = urlSession
    }
    
    func retrieveProductList(completionHandler: @escaping (Data) -> Void) {
        var urlComponents = URLComponents(string: "https://market-training.yagom-academy.kr/api/products?")
        
        let pageNoQuery = URLQueryItem(name: "page_no", value: "2")
        let itemsPerPageQuery = URLQueryItem(name: "items_per_page", value: "10")
        urlComponents?.queryItems?.append(pageNoQuery)
        urlComponents?.queryItems?.append(itemsPerPageQuery)
        
        guard let requestURL = urlComponents?.url else {
            return
        }
        
        let dataTask = urlSession.dataTask(with: requestURL) { (data, response, error) in
            guard error == nil else { return }
            
            let successsRange = 200..<300
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode,
                  successsRange.contains(statusCode) else {
                return
            }
            
            guard let resultData = data else {
                return
            }
            
            let jsonDecoder = JSONDecoder()
            guard let productList = try? jsonDecoder.decode(Products.self, from: resultData) else {
                return
            }
            print(productList)
            completionHandler(resultData)
        }
        
        dataTask.resume()
    }
}
