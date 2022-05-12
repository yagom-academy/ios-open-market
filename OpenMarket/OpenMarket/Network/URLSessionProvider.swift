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

    func fetchData(path: String, parameters: [String: String] = [:], completionHandler: @escaping (Result<T, NetworkError>) -> Void) {
            guard var url = URLComponents(string: API.host + path) else {
                return completionHandler(.failure(.urlError))
            }

            let query = parameters.map { (key: String, value: String) in
                URLQueryItem(name: key, value: value)
            }

            url.queryItems = query
            guard let url = url.url else {
                return completionHandler(.failure(.urlError))
            }

            var request = URLRequest(url: url)
            request.httpMethod = "GET"

            getData(from: request, completionHandler: completionHandler)
        }

    func getData(from urlRequest: URLRequest, completionHandler: @escaping (Result<T, NetworkError>) -> Void) {
        let task = session.dataTask(with: urlRequest) { data, urlResponse, error in
            
            guard error == nil else {
                completionHandler(.failure(.unknownError))
                return
            }
            
            guard let httpResponse = urlResponse as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                completionHandler(.failure(.statusCodeError))
                return
            }
            
            guard let data = data else {
                completionHandler(.failure(.unknownError))
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
