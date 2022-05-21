//
//  URLSession+extension.swift
//  OpenMarket
//
//  Created by dudu, safari on 2022/05/20.
//

import Foundation

extension URLSession {
    static var customSession: URLSession {
        let configuration = URLSessionConfiguration.default
        configuration.waitsForConnectivity = true
        configuration.timeoutIntervalForResource = 300
        return URLSession(configuration: configuration)
    }
}
