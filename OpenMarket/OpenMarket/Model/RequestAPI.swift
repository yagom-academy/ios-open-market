//
//  Request.swift
//  OpenMarket
//
//  Created by 이윤주 on 2021/09/02.
//

import Foundation

protocol RequestAPI {
    var path: String { get }
    var method: HTTPMethod { get }
    var body: Data? { get }
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case patch = "PATCH"
    case delete = "DELETE"
    
    var method: String {
        return self.rawValue
    }
}
