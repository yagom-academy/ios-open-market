//
//  URLSessionProvider.swift
//  OpenMarket
//
//  Created by song on 2022/05/12.
//

import Foundation

struct URLSessionProvider<T: Codable> {
    let session: URLSessionProtocol
    
    init (session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }
    
    func getData(from urlRequest: URLRequest, completionHandler: @escaping (Result<T, NetworkError>) -> Void) {
        let task = session.dataTask(with: urlRequest) { data, urlResponse, error in
            
            guard let data = data, error == nil else {
                completionHandler(.failure(.unknownError))
                return
            }
            
            guard let httpResponse = urlResponse as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                completionHandler(.failure(.statusCodeError))
                return
            }
            
            guard let products = try? JSONDecoder().decode(T.self, from: data) else {
                completionHandler(.failure(.decodeError))
                return
            }
            
            completionHandler(.success(products))
        }
        task.resume()
    }
}
