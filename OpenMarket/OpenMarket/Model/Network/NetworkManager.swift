//
//  NetworkManager.swift
//  OpenMarket
//
//  Created by Hailey, Ryan on 2021/05/11.
//

import Foundation

struct NetworkManager: Requestable {
    
    private let session: URLSession
    
    init(_ session: URLSession) {
        self.session = session
    }
    
    private enum HTTPStatusCode {
        static let success: ClosedRange<Int> = 200...299
    }
    
    func dataTask<Decoded: Decodable>(
        _ urlRequest: URLRequest,
        _ type: Decoded.Type,
        completionHandler: @escaping (Result<Decoded, APIError>) -> Void
    ) {
        session.dataTask(with: urlRequest) { data, response, error in
            guard error == nil else {
                completionHandler(.failure(.requestFailure))
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                completionHandler(.failure(.downcastingFailure("HTTPURLResponse")))
                return
            }
            
            guard isSuccessResponse(response) else {
                completionHandler(.failure(.networkFailure(response.statusCode)))
                return
            }
            
            guard let data = data else {
                completionHandler(.failure(.invalidData))
                return
            }
            
            guard let decodedData = try? JSONDecoder().decode(type.self, from: data) else {
                completionHandler(.failure(.decodingFailure))
                return
            }
            
            completionHandler(.success(decodedData))
        }.resume()
    }
    
    private func isSuccessResponse(_ response: HTTPURLResponse) -> Bool {
        return (HTTPStatusCode.success).contains(response.statusCode)
    }
    
    func request(
        url: URL?,
        httpMethod: HTTPMethod,
        body: Item,
        completionHandler: @escaping (Result<Item, APIError>) -> Void
    ) {
        guard let requestURL = url,
              let request = makeRequest(url: requestURL,
                                        httpMethod: httpMethod,
                                        body: body) else { return }
        
        dataTask(request, Item.self) { result in
            completionHandler(result)
        }
    }
    
    func request<Decoded: Decodable>(
        _ type: Decoded.Type,
        url: URL?,
        completionHandler: @escaping (Result<Decoded, APIError>) -> Void
    ) {
        guard let requestURL = url else { return }
        let request = URLRequest(url: requestURL, httpMethod: .get)
        
        dataTask(request, Decoded.self) { result in
            completionHandler(result)
        }
    }
}
