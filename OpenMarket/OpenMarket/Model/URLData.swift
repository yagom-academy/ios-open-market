//
//  URLData.swift
//  OpenMarket
//
//  Created by 케이, 수꿍 on 2022/07/12.
//

import Foundation

class URLData {
    var session: URLSessionProtocol
    
    init(session: URLSessionProtocol) {
        self.session = session
    }
    
    func fetchData<T: Codable>(url: URLRequestable, dataType: T.Type, completion: @escaping (Result<T,Error>) -> Void) {
        let dataTask: URLSessionDataTaskProtocol = session.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let response = response as? HTTPURLResponse,
               (200..<300).contains(response.statusCode),
               let verifiedData = data {
                do {
                    let decodedData = try JSONDecoder().decode(T.self, from: verifiedData)
                    completion(.success(decodedData))
                } catch {
                    completion(.failure(NetworkError.unableToParse))
                }
            } else {
                completion(.failure(NetworkError.serverSideProblem))
            }
        }
        dataTask.resume()
    }
}
