//
//  URLSessionProvider.swift
//  OpenMarket
//
//  Created by 주디, 재재 on 2022/07/12.
//

import Foundation

enum DataTaskError: Error {
    case incorrectResponse
    case invalidData
}

struct SubURL {
    func pageURL(number: Int, countOfItems: Int) -> String {
        return "api/products?page_no=\(number)&items_per_page=\(countOfItems)"
    }
    
    func productURL(productNumber: Int) -> String {
        return "/api/products/\(productNumber)"
    }
}

final class URLSessionManager {
    private let session: URLSessionProtocol
    private let baseURL = "https://market-training.yagom-academy.kr/"
    
    init(session: URLSessionProtocol) {
        self.session = session
    }
    
   private func dataTask(request: URLRequest, completionHandler: @escaping (Result<Data, DataTaskError>) -> Void) {
       session.dataTask(with: request) { data, urlResponse, error in
            guard let response = urlResponse as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                return completionHandler(.failure(.incorrectResponse))
            }
            
            guard let data = data else {
                return completionHandler(.failure(.invalidData))
            }
            
            return completionHandler(.success(data))
        }.resume()
    }
    
    func receivePage(subURL: String, completionHandler: @escaping (Result<Data, DataTaskError>) -> Void) {
        let pageURL = baseURL + subURL
        
        guard let url = URL(string: pageURL) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        dataTask(request: request, completionHandler: completionHandler)
    }
}



