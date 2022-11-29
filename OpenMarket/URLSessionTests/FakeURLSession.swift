//
//  FakeURLSession.swift
//  URLSessionTests
//
//  Created by Ayaan, junho on 2022/11/16.
//

import Foundation

final class FakeURLSession: OpenMarketURLSessionProtocol {
    var stubURLSession: StubURLSession?
    
    func fetchOpenMarketDataTask(query: String,
                                 completion: @escaping (Data?, Error?) -> Void) -> URLSessionDataTask? {
        return stubURLSession!.dataTask { (data, response, error) in
            if let error = error {
                completion(nil, error)
            } else if (response as? HTTPURLResponse)?.statusCode != 200 {
                completion(nil, OpenMarketError.badStatus())
            } else if let data = data {
                completion(data, nil)
            } else {
                completion(nil, nil)
            }
        }
    }
}

extension FakeURLSession: OpenMarketHealthFetchable { }

extension FakeURLSession: OpenMarketPageFetchable { }

extension FakeURLSession: OpenMarketProductFetchable { }
