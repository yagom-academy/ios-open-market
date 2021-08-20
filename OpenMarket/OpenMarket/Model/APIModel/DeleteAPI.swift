//
//  DeleteAPI.swift
//  OpenMarket
//
//  Created by 오승기 on 2021/08/20.
//

import Foundation

enum DeleteAPI: APIable {
    
    case deleteProduct(id: String, contentType: ContentType, password: String)
    
    var contentType: ContentType {
        switch self {
        case .deleteProduct(id: _, contentType: let contentType, password: _):
            return contentType
        }
    }
    
    var requestType: RequestType {
        switch self {
        case .deleteProduct:
            return .delete
        }
    }
    
    var url: String {
        switch self {
        case .deleteProduct(id: let id, contentType: _, password: _):
            return "\(NetworkManager.baseUrl)/item/\(id)"
        }
    }
    
    var param: [String : String?]? {
        switch self {
        case .deleteProduct(id: _, contentType: _, password: let password):
            return ["password": password.description]
        }
    }
    
    var mediaFile: [Media]? {
        switch self {
        case .deleteProduct:
            return nil
        }
    }
}
