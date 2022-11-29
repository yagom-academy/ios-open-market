//
//  URLSessionProvider.swift
//  OpenMarket
//
//  Created by 써니쿠키, 메네 on 2022/11/15.
//

import UIKit

final class MarketURLSessionProvider {
    private let session: URLSessionProtocol
    private var market: Market?
    
    init(session: URLSessionProtocol = URLSession(configuration: .default)) {
        self.session = session
    }
    
    func fetchData(url: URL, completionHandler: @escaping (Result<Data, NetworkError>) -> Void) {
        let dataTask = session.dataTask(with: url) { data, response, error in
            guard error == nil else {
                return completionHandler(.failure(.requestFailError))
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                return completionHandler(.failure(.httpResponseError(
                    code: (response as? HTTPURLResponse)?.statusCode ?? 0)))
            }
            
            guard let data = data else {
                return completionHandler(.failure(.noDataError))
            }
            
            completionHandler(.success(data))
        }
        
        dataTask.resume()
    }
}
