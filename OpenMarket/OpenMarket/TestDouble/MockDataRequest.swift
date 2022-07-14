//
//  MockDataRequest.swift
//  OpenMarket
//
//  Created by groot, bard on 2022/07/14.
//

import Foundation

extension APIRequest {
    func executeMockData<T: Codable>(completion: @escaping (Result<T, Error>) -> Void) {
        guard let request = self.urlRequest else { return }
        let mockSession = MockURLSession()
        let task = mockSession.dataTask(with: request) { (data, response, error) in
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
