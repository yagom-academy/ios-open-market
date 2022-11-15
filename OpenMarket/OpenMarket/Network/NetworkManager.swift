//  NetworkManager.swift
//  OpenMarket
//  Created by SummerCat & Bella on 2022/11/15.

import Foundation

enum NetworkError: Error {
    case statusCodeError
    case noData
}


class NetworkManager {
    let session: URLSession
    let baseUrl: String = "https://openmarket.yagom-academy.kr"
    
    init(session: URLSession) {
        self.session = session
    }
    
    func checkAPIHealth(request: URLRequest, completion: @escaping (Result<Data, NetworkError>) -> Void) {
        let task = session.dataTask(with: request) { data, urlResponse, error in
            
            guard let httpResponse = urlResponse as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                      return completion(.failure(.statusCodeError))
                  }
            guard let data = data else {
                return completion(.failure(.noData))
            }
            
            print("sucess")
            return completion(.success(data))
        }
        task.resume()
    }
}
