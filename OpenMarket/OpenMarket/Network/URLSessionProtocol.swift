//
//  URLSessionProtocol.swift
//  OpenMarket
//
//  Created by Eddy, marisol on 2022/05/10.
//

import Foundation

typealias DataTaskCompletionHandler = (Response) -> Void

struct Response {
    var data: Data?
    var statusCode: Int
    var error: Error?
}

protocol URLSessionProtocol {
    func dataTask(with endPoint: Endpoint, completionHandler: @escaping DataTaskCompletionHandler)
}

extension URLSession: URLSessionProtocol {
    func dataTask(with endPoint: Endpoint, completionHandler: @escaping DataTaskCompletionHandler) {
        
        guard let url = endPoint.url else {
            return
        }
        
        dataTask(with: url) { data, response, error in
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
                return
            }
            
            let response = Response(data: data, statusCode: statusCode, error: error)
            completionHandler(response)
        }.resume()
    }
}
