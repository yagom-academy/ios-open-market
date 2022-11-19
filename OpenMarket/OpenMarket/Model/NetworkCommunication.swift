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
        completionHandler: @escaping (Result<HTTPURLResponse, Error>) -> ()
    ) {
        guard let url: URL = URL(string: url) else { return }
        
        let task: URLSessionDataTask = session.dataTask(with: url) { _, response, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            if let response = response as? HTTPURLResponse {
                completionHandler(.success(response))
            }
        }
        task.resume()
    }
    
    func requestProductsInformation<T: Decodable>(
        url: String,
        type: T.Type,
        completionHandler: @escaping (Result<Any, Error>) -> ()
    ) {
        guard let url: URL = URL(string: url) else { return }
        
        let task: URLSessionDataTask = session.dataTask(with: url) { data, _, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let data = data else { return }
            
            do {
                let decodingData = try JSONDecoder().decode(type.self, from: data)
                completionHandler(.success(decodingData))
            } catch {
                completionHandler(.failure(error))
            }
        }
        task.resume()
    }
}
