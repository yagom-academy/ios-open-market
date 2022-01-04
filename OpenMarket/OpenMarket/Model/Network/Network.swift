//
//  Network.swift
//  OpenMarket
//
//  Created by 이호영 on 2022/01/04.
//

import Foundation

final class Network {
    let session = URLSession.shared
    
    func execute(request: URLRequest, completion: @escaping (Result<Data?, Error>) -> Void) {
        session.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let response = response as? HTTPURLResponse else {
                completion(.failure(NetworkError.responseCasting))
                return
            }
            guard (200...299).contains(response.statusCode) else {
                completion(.failure(NetworkError.statusCode))
                return
            }
            completion(.success(data))
        }.resume()
    }
    
}
