//
//  URLSession.swift
//  OpenMarket
//
//  Created by Ayaan, junho on 2022/11/15.
//

import Foundation

extension URLSession: OpenMarketURLSessionProtocol {
    func fetchOpenMarketDataTask(query: String,
                                 completion: @escaping (Data?, Error?) -> Void) -> URLSessionDataTask? {
        guard let hostURL: URL = URL(string: host),
              let url: URL = URL(string: query, relativeTo: hostURL) else {
            completion(nil, OpenMarketError.invalidURL(file: #file, line: #line))
            return nil
        }
        
        return self.dataTask(with: url) { (data, response, error) in
            if let error: Error = error {
                completion(nil, error)
            } else if (response as? HTTPURLResponse)?.statusCode != 200 {
                completion(nil, OpenMarketError.badStatus(file: #file, line: #line))
            } else if let data: Data = data {
                completion(data, nil)
            } else {
                completion(nil, nil)
            }
        }
    }
}

extension URLSession: OpenMarketHealthFetchable, OpenMarketPageFetchable, OpenMarketProductFetchable { }
