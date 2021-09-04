//
//  NetworkProtocol.swift
//  OpenMarket
//
//  Created by tae hoon park on 2021/09/01.
//

import Foundation

protocol URLSessionProtocol {
    func dataTask(with request: URLRequest,
                  completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}

extension URLSession: URLSessionProtocol {}

extension URLSessionProtocol {
    func obtainResponseData(data: Data?, response: URLResponse?, error: Error?, statusCode: ClosedRange<Int>) -> Result<Data, NetworkError> {
        if let _ = error {
            return .failure(.dataTaskError)
        }
        guard let response = response as? HTTPURLResponse,
              (statusCode).contains(response.statusCode) else {
            return .failure(.requestFailed)
        }
        guard let data = data else {
            return .failure(.dataNotfound)
        }
        return .success(data)
    }
}
