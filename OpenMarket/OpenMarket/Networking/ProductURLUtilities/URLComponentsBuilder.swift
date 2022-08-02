//
//  URLComponentsBuilder.swift
//  OpenMarket
//
//  Created by 데릭, 수꿍.
//

import Foundation

final class URLComponentsBuilder {
    private var urlComponents = URLComponents()
    
    init() { }
    
    func build() -> URLComponents {
        return urlComponents
    }
    
    func setScheme(_ scheme: String) -> URLComponentsBuilder {
        urlComponents.scheme = scheme
        
        return self
    }
    
    func setHost(_ host: String) -> URLComponentsBuilder {
        urlComponents.host = host
        
        return self
    }
    
    func setPath(_ path: String) -> URLComponentsBuilder {
        urlComponents.path = path
        
        return self
    }
    
    func addQuery(items: [String: String]) -> URLComponentsBuilder {
        urlComponents.addQuery(items)
        
        return self
    }
}

extension URLComponents {
    fileprivate mutating func addQuery(_ items: [String: String]) {
        var newQueryItems = [URLQueryItem]()
        
        for (key, value) in items.sorted(by: { $0.key < $1.key }) {
            newQueryItems.append(URLQueryItem(name: key,
                                              value: value))
        }
        
        if self.queryItems == nil {
            self.queryItems = newQueryItems
        } else {
            self.queryItems?.append(contentsOf: newQueryItems)
        }
    }
}
