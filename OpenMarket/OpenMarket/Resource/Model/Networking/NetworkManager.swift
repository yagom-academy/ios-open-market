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
        guard let url = endPoint.generateURL() else {
            completion(.failure(.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpBody = endPoint.body
        
        endPoint.headers.forEach {
            request.addValue($0.value, forHTTPHeaderField: $0.key)
        }
        request.httpMethod = endPoint.method.rawValue
        
        
//        let task = URLSession.shared.dataTask(with: request) { data, response, error in
//            self.testData = data
//            if let error = error {
//                completion(.failure(.requestError(error: error)))
//                return
//            }
//
//            guard let response = response as? HTTPURLResponse,
//                  let data = data else {
//                completion(.failure(.invalidStatusCode))
//                return
//            }
//
//            print(response)
//        }
        
        let task = session.dataTask(with: url) { data, response, error in
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

            print(response)

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
}
