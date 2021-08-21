//
//  PatchAPI.swift
//  OpenMarket
//
//  Created by 오승기 on 2021/08/20.
//

import Foundation

enum PatchAPI: APIable {
    
    case patchProduct (id: String, contentType: ContentType, title: String?, descriptions:String?, price: Int?, currency: String?, stock: Int?, discountedPrice: Int?, imageFile: [Media]?, password: String)
    
    var requestType: RequestType {
        switch self {
        case .patchProduct:
            return .patch
        }
    }
    
    var contentType: ContentType {
        switch self {
        case .patchProduct(id: _, contentType: let contentType, title: _, descriptions: _, price: _, currency: _, stock: _, discountedPrice: _, imageFile: _, password: _):
            return contentType
        }
    }
    
    var url: String {
        switch self {
        case .patchProduct(id: let id, contentType: _, title: _, descriptions: _, price: _, currency: _, stock: _, discountedPrice: _, imageFile: _, password: _):
            return "\(NetworkManager.baseUrl)/item/\(id)"
        }
    }
    
    var param: [String : String?]? {
        switch self {
        case .patchProduct(id: _, contentType: _, title: let title, descriptions: let descriptions, price: let price, currency: let currency, stock: let stock, discountedPrice: let discountedPrice, imageFile: _, password: let password):
            return ["title": title?.description,
                    "descriptions": descriptions?.description,
                    "price": price?.description,
                    "currency": currency?.description,
                    "stock": stock?.description,
                    "discountedPrice": discountedPrice?.description,
                    "password": password.description]
        }
    }
    
    var mediaFile: [Media]? {
        switch self {
        case .patchProduct(id: _, contentType: _, title: _, descriptions: _, price: _, currency: _, stock: _, discountedPrice: _, imageFile: let imageFile, password: _):
            return imageFile
        }
    }
}
