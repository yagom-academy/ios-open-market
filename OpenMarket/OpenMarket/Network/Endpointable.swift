//  Endpointable.swift
//  OpenMarket
//  Created by SummerCat & Bella on 2022/11/18.
import Foundation

protocol Endpointable {
    var baseUrl: String { get }
    var path: String { get }
    var queries: [String: String] { get }
    
    func createUrl() -> URL?
}

extension Endpointable {
    var baseUrl: String {
        return "https://openmarket.yagom-academy.kr"
    }
    
    func createUrl() -> URL? {
        guard var components = URLComponents(string: baseUrl) else { return nil }
        
        components.path = path
        components.queryItems = queries.map {
            URLQueryItem(name: $0.key, value: $0.value)
        }
        
        return components.url
    }
}
