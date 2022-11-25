//
//  NetworkCommunication.swift
//  OpenMarket
//
//  Created by Mangdi, Woong on 2022/11/16.
//

import Foundation

struct NetworkCommunication {
    let session = URLSession(configuration: .default)
    
    func requestHealthChecker(
        url: String,
        completionHandler: @escaping (Result<HTTPURLResponse, APIError>) -> Void
    ) {
        guard let url: URL = URL(string: url) else {
            completionHandler(.failure(.wrongUrlError))
            return
        }
        
        let task: URLSessionDataTask = session.dataTask(with: url) { _, response, error in
            if error != nil {
                completionHandler(.failure(.unkownError))
                return
            }
            
            if let response = response as? HTTPURLResponse {
                if !(200...299).contains(response.statusCode) {
                    print("URL요청 실패 : 코드\(response.statusCode)")
                    completionHandler(.failure(.statusCodeError))
                    return
                }
                completionHandler(.success(response))
            }
        }
        task.resume()
    }
    
    func requestProductsInformation<T: Decodable>(
        url: String,
        type: T.Type,
        completionHandler: @escaping (Result<T, APIError>) -> Void
    ) {
        guard let url: URL = URL(string: url) else {
            completionHandler(.failure(.wrongUrlError))
            return
        }
        
        let task: URLSessionDataTask = session.dataTask(with: url) { data, response, error in
            if error != nil {
                completionHandler(.failure(.unkownError))
                return
            }
            
            if let response = response as? HTTPURLResponse {
                if !(200...299).contains(response.statusCode) {
                    print("URL요청 실패 : 코드\(response.statusCode)")
                    completionHandler(.failure(.statusCodeError))
                    return
                }
            }
            
            if let data = data {
                do {
                    let decodingData = try JSONDecoder().decode(type.self, from: data)
                    completionHandler(.success(decodingData))
                } catch {
                    completionHandler(.failure(.jsonDecodingError))
                }
            }
        }
        task.resume()
    }
}
