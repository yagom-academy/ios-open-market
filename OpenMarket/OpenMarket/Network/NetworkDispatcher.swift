//
//  NetworkDispatcher.swift
//  OpenMarket
//
//  Created by Wonhee on 2021/01/29.
//

import Foundation

class NetworkDispatcher {
    func execute(request: Request, completion: @escaping (Result<Any, Error>) -> Void) {
        guard let url = URL(string: request.path) else {
            return completion(.failure(NetworkError.wrongRequest))
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue
        if let headers = request.headers {
            for header in headers {
                urlRequest.addValue(header.value, forHTTPHeaderField: header.key)
            }
        }
        if let body = request.bodyParams {
            urlRequest.httpBody = body
        }

        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if error != nil {
                return completion(.failure(NetworkError.serverResponse))
            }
            
            guard let response = response as? HTTPURLResponse,
                  (200...299).contains(response.statusCode) else {
                return completion(.failure(NetworkError.serverResponse))
            }
            
            guard let data = data else {
                return completion(.failure(NetworkError.receiveData))
            }
            
            completion(.success(data))
        }.resume()
    }
}
