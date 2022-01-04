//
//  URLSessionProvider.swift
//  OpenMarket
//
//  Created by JeongTaek Han on 2022/01/04.
//

import Foundation

enum URLSessionProviderError: Error {
    case statusError
    case unknownError
}

protocol URLSessionProtocol {
    func dataTask(with request: URLRequest,
                  completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}

class URLSessionProvider {
    let session: URLSessionProtocol
    var baseURL: String = "https://market-training.yagom-academy.kr/"
    
    init(session: URLSessionProtocol, baseURL: String) {
        self.session = session
        self.baseURL = baseURL
    }
    
    func request(_ service: OpenMarketService, completionHandler: @escaping (Result<Data, URLSessionProviderError>) -> Void) {
        let task = session.dataTask(with: service.urlRequest) { data, response, _ in
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
}

extension URLSession: URLSessionProtocol { }
