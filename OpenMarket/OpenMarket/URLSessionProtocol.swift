//
//  URLSessionProtocol.swift
//  OpenMarket
//
//  Created by marisol on 2022/05/10.
//

import Foundation

protocol URLSessionProtocol {
    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}
