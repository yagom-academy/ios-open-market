//
//  URLSessionProtocol.swift
//  OpenMarket
//
//  Created by papri, Tiana on 11/05/2022.
//

import Foundation

protocol URLSessionProtocol {
    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}

extension URLSession: URLSessionProtocol { }
