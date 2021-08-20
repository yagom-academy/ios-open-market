//
//  PostAPI.swift
//  OpenMarket
//
//  Created by 오승기 on 2021/08/20.
//

import Foundation

enum PostAPI: APIable {
    
    case registrateProduct(title: String, contentType: ContentType, descriptions:String, price: Int, currency: String, stock: Int, discountedPrice: Int?, mediaFile: [Media], password: String)
    
    var contentType: ContentType {
        switch self {
        case .registrateProduct(title: _, contentType: let contentType, descriptions: _, price: _, currency: _, stock: _, discountedPrice: _, mediaFile: _, password: _):
            return contentType
        }
    }
    
    var mediaFile: [Media]? {
        switch self {
        case .registrateProduct(title: _, contentType: _, descriptions: _, price: _, currency: _, stock: _, discountedPrice: _, mediaFile: let mediaFile, password: _):
            return mediaFile
        }
    }
    
    var requestType: RequestType {
        switch self {
        case .registrateProduct:
            return RequestType.post
        }
    }
    
    var url: String {
        switch self {
        case .registrateProduct:
            return "\(NetworkManager.baseUrl)/item"
        }
    }
    
    var param: [String : String?]? {
        switch self {
        case .registrateProduct(title: let title, contentType: _, descriptions: let descriptions, price: let price, currency: let currency, stock: let stock, discountedPrice: let discountedPrice, mediaFile: _, password: let password):
            return ["title": title,
                    "descriptions": descriptions,
                    "price": price.description,
                    "currency": currency,
                    "stock": stock.description,
                    "discountedPrice": discountedPrice?.description,
                    "password": password]
        }
    }
}
