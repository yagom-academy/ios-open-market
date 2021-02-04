//
//  URLSessionExtension.swift
//  OpenMarket
//
//  Created by Kyungmin Lee on 2021/01/30.
//

import Foundation

extension URLSession {
    func startDataTask<T>(_ requestData: RequestData<T>, completionHandler: @escaping (T?, Error?) -> Void) {
        dataTask(with: requestData.urlRequest) { (data, response, error) in
            if let response = response as? HTTPURLResponse, (200..<300).contains(response.statusCode) {
                completionHandler(data.flatMap(requestData.parseJSON), error)
            } else {
                completionHandler(nil, error)
            }
        }.resume()
    }
}

protocol URLSessionProtocol {
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
    
    func startDataTask<T>(_ requestData: RequestData<T>, completionHandler: @escaping (T?, Error?) -> Void)
}
extension URLSession: URLSessionProtocol { }
