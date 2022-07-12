//
//  URLSessionProvider.swift
//  OpenMarket
//
//  Created by 주디, 재재 on 2022/07/12.
//

import Foundation

enum DataTaskError: Error {
    case incorrectResponseError
    case invalidDataError
}

struct URLSessionProvider {
    let session: URLSessionProtocol
    let baseURL = "https://market-training.yagom-academy.kr/"
    
    init(session: URLSessionProtocol) {
        self.session = session
    }
    
    func dataTask(request: URLRequest, completionHandler: @escaping (Result<Data, DataTaskError>) -> Void) {
        let task = session.dataTask(with: request) { data, urlResponse, error in
            guard let response = urlResponse as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                return completionHandler(.failure(.incorrectResponseError))
            }
            
            guard let data = data else {
                return completionHandler(.failure(.invalidDataError))
            }
            
            return completionHandler(.success(data))
        }
        
        task.resume()
    }
    
    func receivePage(number: Int, countOfItems: Int, completionHandler: @escaping (Result<Data, DataTaskError>) -> Void) {
        let pageUrl = baseURL + "api/products?page_no=\(number)&items_per_page=\(countOfItems)"
        
        guard let url = URL(string: pageUrl) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        dataTask(request: request, completionHandler: completionHandler)
    }
}
