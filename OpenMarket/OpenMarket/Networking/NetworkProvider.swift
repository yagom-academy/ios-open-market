//
//  NetworkProvider.swift
//  OpenMarket
//
//  Created by 케이, 수꿍 on 2022/07/12.
//

import Foundation

class NetworkProvider {
    var session: URLSessionProtocol
    
    init(session: URLSessionProtocol) {
        self.session = session
    }
    
    func fetchData<T: Codable>(url: URLAlternativeProtocol, dataType: T.Type, completion: @escaping (Result<T,NetworkError>) -> Void) {
        let dataTask: URLSessionDataTaskProtocol = session.dataTask(with: url) { data, response, error in
            if error != nil {
                completion(.failure(.unknownErrorOccured))
                return
            }
            
            if let response = response as? HTTPURLResponse,
               (200..<300).contains(response.statusCode),
               let verifiedData = data {
                do {
                    let decodedData = try JSONDecoder().decode(T.self, from: verifiedData)
                    completion(.success(decodedData))
                } catch {
                    completion(.failure(.failedToDecode))
                }
            } else {
                completion(.failure(.networkConnectionIsBad))
            }
        }
        dataTask.resume()
    }
}
