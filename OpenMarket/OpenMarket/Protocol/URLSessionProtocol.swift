//
//  NetworkProtocol.swift
//  OpenMarket
//
//  Created by tae hoon park on 2021/09/01.
//

import Foundation

protocol URLSessionProtocol {
    func dataTask(
        with request: URLRequest,
        completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void
    ) -> URLSessionDataTask
}

extension URLSession: URLSessionProtocol {}

extension URLSessionProtocol {
    func obtainResponseData(
        data: Data?,
        response: URLResponse?,
        error: Error?) -> Result<Data, NetworkError> {
        let rangeOfSuccessState = 200...299
        if let _ = error {
            return .failure(.dataTaskError)
        }
        guard let response = response as? HTTPURLResponse,
              (rangeOfSuccessState).contains(response.statusCode) else {
            return .failure(.requestFailed)
        }
        guard let data = data else {
            return .failure(.dataNotfound)
        }
        return .success(data)
    }
}
