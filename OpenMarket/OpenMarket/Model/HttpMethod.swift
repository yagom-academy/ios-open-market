//
//  HttpMethod.swift
//  OpenMarket
//
//  Created by Luyan, Ellen on 2021/08/19.
//

import Foundation

enum HttpMethod: String, CustomStringConvertible {
    case get    = "GET"
    case post   = "POST"
    case patch  = "PATCH"
    case delete = "DELETE"
    
    var description: String {
        return self.rawValue
    }
}
