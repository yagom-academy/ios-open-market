//
//  NetworkManager.swift
//  OpenMarket
//
//  Copyright (c) 2022 Minii All rights reserved.

import Foundation

class NetworkManager<T: Decodable> {
    var session: URLSessionProtocol = URLSession.shared
    var testData: Data?
    
    func fetchData(endPoint: APIType, completion: @escaping (Result<T, NetworkError>) -> Void) {
        guard let request = endPoint.generateRequest() else {
            completion(.failure(.invalidURL))
            return
        }
        
        let task = session.dataTask(with: request) { data, response, error in
            self.testData = data
            if let error = error {
                completion(.failure(.requestError(error: error)))
                return
            }

            guard let response = response as? HTTPURLResponse,
                  response.statusCode == 200,
                  let data = data else {
                completion(.failure(.invalidStatusCode))
                return
            }

            let decoder = JSONDecoder()

            do {
                let fetchData = try decoder.decode(T.self, from: data)
                completion(.success(fetchData))
            } catch {
                completion(.failure(.decodeError))
            }
        }
        
        task.resume()
    }
    
    func postProduct(endPoint: APIType, completion: @escaping (Result<Bool, NetworkError>) -> Void) {
        guard let request = endPoint.generateRequest() else {
            completion(.failure(.invalidURL))
            return
        }
        
        let task = session.dataTask(with: request) { data, response, error in
            self.testData = data
            if let error = error {
                completion(.failure(.requestError(error: error)))
                return
            }

            guard let response = response as? HTTPURLResponse,
                  (200..<300) ~= response.statusCode else {
                completion(.failure(.invalidStatusCode))
                return
            }
            
            completion(.success(true))
        }
        
        task.resume()
    }
}
