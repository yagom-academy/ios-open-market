//
//  NameSpace.swift
//  OpenMarket
//
//  Created by Do Yi Lee on 2021/08/13.
//

import Foundation

enum MimeType: CustomStringConvertible {
    case jpeg
    case png
    
    var description: String {
        switch self {
        case .jpeg:
            return "image/jpeg"
        case .png:
            return "imgae/png"
        }
    }
}

enum ContentType: CustomStringConvertible {
    case multipart
    
    var description: String {
        switch self {
        case .multipart:
            return "multipart/form-data"
        }
    }
}

enum APIKey: CustomStringConvertible {
    case title, descriptions, price, currency, stock, discountedPrice, images, password
    
    var description: String {
        switch self {
        case .title:
            return "title"
        case .descriptions:
            return "descriptions"
        case .price:
            return "price"
        case .currency:
            return "currency"
        case .stock:
            return "stock"
        case .discountedPrice:
            return "discounted_price"
        case .images :
            return "images[]"
        case .password:
            return "password"
        }
    }
}

enum HTTPMethod: CustomStringConvertible {
    case get
    case post
    case patch
    case delete
    
    var description: String {
        switch self {
        case .get:
            return "GET"
        case .post:
            return "POST"
        case .patch:
            return "PATCH"
        case .delete:
            return "DELETE"
        }
    }
}
