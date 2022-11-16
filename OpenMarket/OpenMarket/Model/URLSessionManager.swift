//
//  URLSessionManager.swift
//  OpenMarket
//
//  Created by Ash and som on 2022/11/15.
//

import Foundation

class URLSessionManager {
    let session: URLSession
    let baseURL = OpenMarketURL.base
    
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    private func dataTask(request: URLRequest, completionHandler: @escaping (Result<Data, CustomError>) -> Void) {
        let task = session.dataTask(with: request) { data, urlResponse, error in
            guard let httpResponse = urlResponse as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
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
        guard let url = URL(string: baseURL + OpenMarketURL.heathChecker) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.get
        
        dataTask(request: request, completionHandler: completionHandler)
    }
    
    func getItemsPerPage(completionHandler: @escaping (Result<Data, CustomError>) -> Void) {
        guard let url = URL(string: baseURL + OpenMarketURL.itemPage) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.get
        
        dataTask(request: request, completionHandler: completionHandler)
    }
    
    func getProducts(completionHandler: @escaping (Result<Data, CustomError>) -> Void) {
        guard let url = URL(string: baseURL + OpenMarketURL.product) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.get
        
        dataTask(request: request, completionHandler: completionHandler)
    }
}

enum CustomError: Error {
    case statusCodeError
    case unknownError
}
