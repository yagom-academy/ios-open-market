//
//  NameSpace.swift
//  OpenMarket
//
//  Created by Do Yi Lee on 2021/08/13.
//

import Foundation

//MARK:- HTTP reqeust of OpenMarket server API
enum OpenMarketUrl: CustomStringConvertible {
    static let baseUrl = "https://camp-open-market-2.herokuapp.com/"
    
    case listLookUp
    case itemLookup, itemUpdate, itemDelete
    
    var description: String {
        switch self {
        case .listLookUp:
            return Self.baseUrl + "items/"
        case .itemLookup, .itemUpdate, .itemDelete:
            return Self.baseUrl + "item/"
        }
    }
}

//MARK:-HTTP Method Content Type
enum ContentType: CustomStringConvertible {
    case multipart
    case json
    var description: String {
        switch self {
        case .multipart:
            return "multipart/form-data"
        case .json:
            return "aplication/json"
        }
    }
}

//MARK:-API key of OpenMarket server
enum RequestAPIKey: CustomStringConvertible {
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

//MARK:-HTTP Method of OpenMarket server
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

//MARK:-Boundary used in HTTP Body and Header
enum Boundary {
    static let literal = "Boundary\(UUID().uuidString)"
}
