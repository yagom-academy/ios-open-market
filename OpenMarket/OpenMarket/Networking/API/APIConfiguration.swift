//
//  APIConfiguration.swift
//  OpenMarket
//
//  Created by 전민수 on 2022/07/26.
//

import Foundation

typealias Parameters = [String: String]

struct APIConfiguration {
    let method: HTTPMethod
    let url: URL
    let parameters: Parameters?
    
    init(method: HTTPMethod,
         url: URL,
         parameters: Parameters? = nil) {
        
        self.method = method
        self.url = url
        self.parameters = parameters
    }
}
