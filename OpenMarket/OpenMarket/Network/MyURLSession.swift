//
//  MyURLSession.swift
//  OpenMarket
//
//  Created by groot, bard on 2022/07/15.
//

import Foundation

final class MyURLSession: SessionProtocol {
    func dataTask(with request: APIRequest,
                              completionHandler: @escaping (Result<Data, Error>) -> Void) {
        execute(with: request, completionHandler: completionHandler)
    }
    
    func execute(with request: APIRequest,
                             completionHandler: @escaping (Result<Data, Error>) -> Void) {
        guard let request = request.urlRequest else {
            completionHandler(.failure(NetworkError.request))
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard error == nil else {
                completionHandler(.failure(NetworkError.request))
                return
            }
            
            guard let response = response as? HTTPURLResponse,
                  200 <= response.statusCode, response.statusCode < 300
            else {
                completionHandler(.failure(NetworkError.response))
                return
            }
            
            guard let safeData = data else {
                completionHandler(.failure(NetworkError.invalidData))
                return
            }
            
            completionHandler(.success(safeData))
        }
        task.resume()
    }
}
