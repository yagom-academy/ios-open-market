//
//  URLSessionManager.swift
//  OpenMarket
//
//  Created by Ash and som on 2022/11/15.
//

import Foundation

class URLSessionManager {
    let session: URLSession
    let baseURL = "https://openmarket.yagom-academy.kr"
    
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    func dataTask(request: URLRequest, completionHandler: @escaping (Result<Data, CustomError>) -> Void) {
        let task = session.dataTask(with: request) { data, urlResponse, error in
            guard let httpResonse = urlResponse as? HTTPURLResponse,
                  (200...299).contains(httpResonse.statusCode) else {
                return completionHandler(.failure(.statusCodeError))
            }
            
            if let data = data {
                return completionHandler(.success(data))
            }
            
            completionHandler(.failure(.unknownError))
        }
        task.resume()
    }
    
    func getHeathChecker(completionHandler: @escaping (Result<Data, CustomError>) -> Void) {
        guard let url = URL(string: baseURL + "/healthChecker") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.get.rawValue
        
        dataTask(request: request, completionHandler: completionHandler)
    }
    
    func getItemsPerPage(completionHandler: @escaping (Result<Data, CustomError>) -> Void) {
        guard let url = URL(string: baseURL + "/api/products?page_no=1&items_per_page=100") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.get.rawValue
        
        dataTask(request: request, completionHandler: completionHandler)
    }
    
    func getProducts(completionHandler: @escaping (Result<Data, CustomError>) -> Void) {
        guard let url = URL(string: baseURL + "/api/products/32") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.get.rawValue
        
        dataTask(request: request, completionHandler: completionHandler)
    }
}

enum CustomError: Error {
    case statusCodeError
    case unknownError
}
