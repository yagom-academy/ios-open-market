//
//  URLSessionProvider.swift
//  OpenMarket
//
//  Created by 써니쿠키, 메네 on 2022/11/15.
//

import Foundation

final class MarketURLSessionProvider {
    private let session: URLSessionProtocol
    private var market: Market?
    
    init(session: URLSessionProtocol = URLSession(configuration: .default)) {
        self.session = session
    }
    
    func fetchData<T: Decodable>(url: URL,
                                 type: T.Type,
                                 completionHandler: @escaping (Result<T, NetworkError>) -> Void) {
        let dataTask = session.dataTask(with: url) { data, response, error in
            guard error == nil else {
                return completionHandler(.failure(.requestFailError))
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                return completionHandler(.failure(.httpResponseError(
                    code: (response as? HTTPURLResponse)?.statusCode ?? 0)))
            }
            
            guard let mimeType = httpResponse.mimeType,
                  mimeType == "application/json" else {
                return completionHandler(.failure(.mimeTypeError))
            }
            
            guard let data = data else {
                return completionHandler(.failure(.noDataError))
            }
            
            guard let decodedData = JSONDecoder.decodeFromSnakeCase(type: type, from: data) else {
                return completionHandler(.failure(.decodingError))
            }
            
            completionHandler(.success(decodedData))
        }
        
        dataTask.resume()
    }
}
