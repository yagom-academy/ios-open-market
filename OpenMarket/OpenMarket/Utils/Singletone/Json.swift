//
//  Json.swift
//  OpenMarket
//
//  Created by marlang, Taeangel on 2022/05/14.
//

import Foundation

struct Json {
    static let decoder = JSONDecoder()
    static let encoder: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        return encoder
    }()
    
    private init() {}
}
