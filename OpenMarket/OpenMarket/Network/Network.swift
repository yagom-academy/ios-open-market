//
//  Network.swift
//  OpenMarket
//
//  Created by dudu, safari on 2022/05/10.
//

import Foundation

enum NetworkErorr: Error {
    case unknown
    case jsonError
    case severError
    case urlError
}
extension URLComponents {
    mutating func configureQuery(_ paramters: [String: String]) {
        self.queryItems = paramters.map{ (key, value) in
            URLQueryItem(name: key, value: value)
        }
    }
}
