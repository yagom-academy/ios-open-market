//
//  APIConfiguration.swift
//  OpenMarket
//
//  Created by 전민수 on 2022/07/26.
//

import Foundation

typealias Parameters = [String: String]

struct APIConfiguration {
    let url: URL
    let parameters: Parameters?
    
    init(url: URL,
         parameters: Parameters? = nil) {
        
        self.url = url
        self.parameters = parameters
    }
}
