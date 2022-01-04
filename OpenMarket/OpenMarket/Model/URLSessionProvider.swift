//
//  URLSessionProvider.swift
//  OpenMarket
//
//  Created by JeongTaek Han on 2022/01/04.
//

import Foundation

enum URLSessionProviderError: Error {
    case statusError
}

class URLSessionProvider {
    let session: URLSession
    var baseURL: String = "https://market-training.yagom-academy.kr/"
    
    init(session: URLSession, baseURL: String) {
        self.session = session
        self.baseURL = baseURL
    }
    
    func request(_ request: URLRequest, completionHandler: @escaping (Result<Data, URLSessionProviderError>) -> Void) {
        let task = session.dataTask(with: request) { data, response, error in
            guard let httpRespose = response as? HTTPURLResponse,
                  (200...299).contains(httpRespose.statusCode) else {
                return completionHandler(.failure(.statusError))
            }
            guard let data = data else {
                return completionHandler(.failure(.statusError))
            }
            return completionHandler(.success(data))
        }
        task.resume()
    }
}
