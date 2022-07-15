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
        execute(with: request, completion: completionHandler)
    }
    
    func execute<T: Codable>(with request: APIRequest,
                             completion: @escaping (Result<T, Error>) -> Void) {
        guard let request = request.urlRequest else {
            completion(.failure(NetworkError.request))
            return
        }
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard error == nil else {
                completion(.failure(NetworkError.request))
                return
            }
            guard let response = response as? HTTPURLResponse,
                  200 <= response.statusCode, response.statusCode < 300
            else {
                completion(.failure(NetworkError.response))
                return
            }
            guard let safeData = data else {
                completion(.failure(NetworkError.invalidData))
                return
            }
            guard let decodedData = try? JSONDecoder().decode(T.self, from: safeData)
            else {
                completion(.failure(CodableError.decode))
                return
            }
            completion(.success(decodedData))
        }
        task.resume()
    }
}
