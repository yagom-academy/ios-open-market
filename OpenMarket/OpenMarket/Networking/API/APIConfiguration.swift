//
//  APIConfiguration.swift
//  OpenMarket
//
//  Created by 데릭, 수꿍.
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
