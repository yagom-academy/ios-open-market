//
//  Sessionable.swift
//  OpenMarket
//
//  Created by Ari on 2022/01/05.
//

import Foundation

protocol Sessionable {
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}

extension URLSession: Sessionable {}
