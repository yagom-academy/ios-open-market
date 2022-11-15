//
//  NetworkManager.swift
//  OpenMarket
//
//  Created by Gundy, Wonbi on 2022/11/15.
//

import Foundation

enum NetworkError: Error {
    case failToParse
    case invalid
}

final class NetworkManager {
    let session: URLSessionProtocol
    
    init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }
    
    func fetchData<T: Decodable>(for request: URLRequest?,
                                 dataType: T.Type,
                                 completion: @escaping (Result<T, Error>) -> Void) {
        guard let request = request else { return }
        
        let dataTask: URLSessionDataTaskProtocol = session.dataTask(with: request) {
            (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data,
                  let response = response as? HTTPURLResponse,
                  200..<400 ~= response.statusCode else {
                return completion(.failure(NetworkError.invalid))
            }
            
            guard let data = JSONDecoder.decode(T.self, from: data) else {
                return completion(.failure(NetworkError.failToParse))
            }
            
            completion(.success(data))
        }
        dataTask.resume()
    }
}
