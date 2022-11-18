//  NetworkManager.swift
//  OpenMarket
//  Created by SummerCat & Bella on 2022/11/15.

import Foundation

final class NetworkManager {
    func request<Model: Decodable>(endpoint: Endpointable,
                                   dataType: Model.Type,
                                   completion: @escaping (Result<Model, NetworkError>) -> Void) {
        guard let url = endpoint.createURL() else {
            return completion(.failure(.URLError))
        }
        
        let request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                return completion(.failure(.URLError))
            }
            
            guard let response = response as? HTTPURLResponse,
                  (200..<300).contains(response.statusCode) else {
                      return completion(.failure(.statusCodeError))
            }
            
            guard let data = data else {
                return completion(.failure(.noData))
            }
            
            do {
                let result = try JSONDecoder().decode(dataType, from: data)
                completion(.success(result))
            } catch {
                completion(.failure(.decodingError))
            }
        }
        
        task.resume()
    }
    
    func checkAPIHealth(endpoint: Endpointable,
                        completion: @escaping (Result<String, NetworkError>) -> Void) {
        guard let url = endpoint.createURL() else {
            return completion(.failure(.URLError))
        }
        
        let request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                return completion(.failure(.URLError))
            }
            
            guard let response = response as? HTTPURLResponse,
                  (200..<300).contains(response.statusCode) else {
                      return completion(.failure(.statusCodeError))
            }
            
            guard let data = data else {
                return completion(.failure(.noData))
            }
            
            completion(.success(String(decoding: data, as: UTF8.self)))
        }
        
        task.resume()
    }
}
