//
//  MyURLSession.swift
//  OpenMarket
//
//  Created by groot, bard on 2022/07/15.
//

import Foundation

class MyURLSession: SessionProtocol {
    func dataTask<T: Codable>(with request: APIRequest,
                              completionHandler: @escaping (Result<T, Error>) -> Void) {
        execute(with: request, completionHandler: completionHandler)
    }
    
    func execute<T: Codable>(with request: APIRequest,
                             completionHandler: @escaping (Result<T, Error>) -> Void) {
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
            guard let decodedData = try? JSONDecoder().decode(T.self, from: safeData)
            else {
                completionHandler(.failure(CodableError.decode))
                return
            }
            completionHandler(.success(decodedData))
        }
        task.resume()
    }
}
