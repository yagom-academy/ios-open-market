//
//  NetworkManager.swift
//  OpenMarket
//
//  Copyright (c) 2022 Minii All rights reserved.

import Foundation

struct NetworkManager<T: Decodable> {
    private var session: URLSession = URLSession(configuration: .default)
    private var endPoint: APIType
    
    init(endPoint: APIType) {
        self.endPoint = endPoint
    }
    
    func fetchData(completion: @escaping (Result<T, NetworkError>) -> Void) {
        guard let url = endPoint.generateURL() else {
            completion(.failure(.invalidURL))
            return
        }
        
        let task = session.dataTask(with: url) { data, response, error in
            guard error == nil else {
                completion(.failure(.requestError))
                return
            }
            
            guard let response = response as? HTTPURLResponse,
                  response.statusCode == 200,
                  let data = data else {
                completion(.failure(.responseError))
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
}
