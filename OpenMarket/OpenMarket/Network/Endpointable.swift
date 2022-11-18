//  Endpointable.swift
//  OpenMarket
//  Created by SummerCat & Bella on 2022/11/18.

import Foundation

protocol Endpointable {
    var baseURL: String { get }
    var path: String { get }
    var queries: [String: String] { get }
    
    func createURL() -> URL?
}

extension Endpointable {
    var baseURL: String {
        return "https://openmarket.yagom-academy.kr"
    }
    
    func createURL() -> URL? {
        guard var components = URLComponents(string: baseURL) else { return nil }
        
        components.path = path
        components.queryItems = queries.map {
            URLQueryItem(name: $0.key, value: $0.value)
        }
        
        return components.url
    }
}
