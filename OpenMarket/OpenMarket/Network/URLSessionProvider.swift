//
//  URLSessionProvider.swift
//  OpenMarket
//
//  Created by marlang, Taeangel on 2022/05/12.
//

import Foundation

struct URLSessionProvider<T: Decodable> {
    private let session: URLSessionProtocol
    
    init (session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }
    
    func getData(
        from url: Endpoint,
        completionHandler: @escaping (Result<T, NetworkError>) -> Void
    ) {
        guard let url = url.url else {
            completionHandler(.failure(.urlError))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = session.dataTask(with: request) { data, urlResponse, error in
            
            guard error == nil else {
                completionHandler(.failure(.clientError))
                return
            }
            
            guard let httpResponse = urlResponse as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                completionHandler(.failure(.statusCodeError))
                return
            }
            
            guard let data = data else {
                completionHandler(.failure(.dataError))
                return
            }
            
            let json = JSONDecoder()
            json.keyDecodingStrategy = .convertFromSnakeCase
            guard let products = try? json.decode(T.self, from: data) else {
                completionHandler(.failure(.decodeError))
                return
            }
            
            completionHandler(.success(products))
        }
        task.resume()
    }
}
