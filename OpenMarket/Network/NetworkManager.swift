//
//  NetworkManager.swift
//  OpenMarket
//
//  Created by Gundy, Wonbi on 2022/11/15.
//

import Foundation

final class NetworkManager {
    var session: URLSessionProtocol
    
    init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }
    
    func fetchData<T: Decodable>(from request: URLRequest,
                                 dataType: T.Type,
                                 completion: @escaping (Result<T, Error>) -> Void) {
        let dataTask: URLSessionDataTaskProtocol = session.dataTask(with: request) {
            (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse,
               httpResponse.statusCode >= 300 {
                completion(.failure(NetworkError.responseFailed(code: httpResponse.statusCode)))
                return
            }
            
            guard let data = data,
                  let data = JSONDecoder.decode(T.self, from: data) else {
                      completion(.failure(NetworkError.invalidData))
                      return
                  }
            completion(.success(data))
        }
        dataTask.resume()
    }
    
    func postData(from request: URLRequest, completion: @escaping (Result<Data, Error>) -> Void) {
        let dataTask: URLSessionDataTaskProtocol = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse,
               httpResponse.statusCode >= 300 {
                completion(.failure(NetworkError.responseFailed(code: httpResponse.statusCode)))
                print(String(data: data!, encoding: .utf8)!)
                return
            }
            
            guard let data = data else {
                completion(.failure(NetworkError.invalidData))
                return
            }
            
            completion(.success(data))
        }
        dataTask.resume()
    }
}
