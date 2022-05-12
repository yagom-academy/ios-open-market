//
//  URLSessionProvider.swift
//  OpenMarket
//
//  Created by song on 2022/05/12.
//

import Foundation

struct URLSessionProvider<T: Codable> {
    let session = URLSession.shared
    
    func getData(from url: URL, completionHandler: @escaping (Result<T, NetworkError>) -> Void) {
        let task = session.dataTask(with: url) { data, urlResponse, error in
            
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
