//
//  URLSession+Extension.swift
//  OpenMarket
//
//  Created by 조민호 on 2022/05/12.
//

import Foundation

extension URLSession: URLSessionProtocol {
    func dataTask(with urlRequset: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {
        return dataTask(with: urlRequset, completionHandler: completionHandler) as URLSessionDataTask
    }
    
    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {
        return dataTask(with: url, completionHandler: completionHandler) as URLSessionDataTask
    }
}

extension URLSessionDataTask: URLSessionDataTaskProtocol {}
