//
//  URLSessionProvider.swift
//  OpenMarket
//
//  Created by JeongTaek Han on 2022/01/04.
//

import Foundation

class URLSessionProvider {
    
    let session: URLSessionProtocol
    
    init(session: URLSessionProtocol) {
        self.session = session
    }
    func request(_ service: OpenMarketService,
                 completionHandler: @escaping (Result<Data, URLSessionProviderError>) -> Void) {
        guard let urlRequest = service.urlRequest else {
            completionHandler(.failure(.urlRequestError))
            return
        }
        
        let task = session.dataTask(with: urlRequest) { data, response, _ in
            
            print(String(data: data!, encoding: .utf8))
            
            guard let httpRespose = response as? HTTPURLResponse,
                  (200...299).contains(httpRespose.statusCode) else {
                return completionHandler(.failure(.statusError))
            }
            guard let data = data else {
                return completionHandler(.failure(.unknownError))
            }
            return completionHandler(.success(data))
        }
        task.resume()
    }
    
    func request<T: Decodable>(_ service: OpenMarketService,
                 completionHandler: @escaping (Result<T, URLSessionProviderError>) -> Void) {
        guard let urlRequest = service.urlRequest else {
            completionHandler(.failure(.urlRequestError))
            return
        }
        
        let task = session.dataTask(with: urlRequest) { data, response, _ in
            
            print(String(data: data!, encoding: .utf8))
            
            guard let httpRespose = response as? HTTPURLResponse,
                  (200...299).contains(httpRespose.statusCode) else {
                return completionHandler(.failure(.statusError))
            }
            
            guard let data = data else {
                return completionHandler(.failure(.unknownError))
            }
            
            guard let decoded = try? JSONDecoder.shared.decode(T.self, from: data) else {
                return completionHandler(.failure(.unknownError))
            }
            
            return completionHandler(.success(decoded))
        }
        task.resume()
    }
    
}

enum URLSessionProviderError: Error {
    
    case statusError
    case urlRequestError
    case unknownError
    
}
