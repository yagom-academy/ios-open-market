//
//  PostParameter.swift
//  OpenMarket
//
//  Copyright (c) 2022 Minii All rights reserved.
        
import Foundation

struct PostParameter: Encodable, HttpBodyConvertible {
    let name: String
    let description: String
    let price: Double
    let currency: Currency
    let discounted_price: Double?
    let stock: Int?
    let secret: String = "4e5jv489csufrgs4"
    
    var contentType: ContentType {
        return .json
    }
    
    var data: Data {
        guard let data = try? JSONEncoder().encode(self) else {
            return Data()
        }
        
        return data
    }
    
}
