//
//  TestProtocol.swift
//  OpenMarket
//
//  Created by Theo on 2021/08/17.
//

import Foundation

protocol URLSessionProtocol {
    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}

extension URLSession: URLSessionProtocol {
    
}
