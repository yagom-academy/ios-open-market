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
    var session: URLSessionProtocol
    
    init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }
    
    func fetchData<T: Decodable>(for url: URL,
                                 dataType: T.Type,
                                 completion: @escaping (Result<T, Error>) -> Void) {
        let dataTask: URLSessionDataTaskProtocol = session.dataTask(with: url) {
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
