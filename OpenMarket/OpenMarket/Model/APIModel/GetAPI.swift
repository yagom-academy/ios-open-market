//
//  GetAPI.swift
//  OpenMarket
//
//  Created by 오승기 on 2021/08/20.
//

import Foundation

enum GetAPI: APIable {
    
    case lookUpProductList(page: Int, contentType: ContentType)
    case lookUpProduct(id: String, contentType: ContentType)
    
    var contentType: ContentType {
        switch self {
        case .lookUpProductList(page: _, contentType: let contentType):
            return contentType
        case .lookUpProduct(id: _,  contentType: let contentType):
            return contentType
        }
    }
    
    var requestType: RequestType {
        switch self {
        case .lookUpProductList:
            return .get
        case .lookUpProduct:
            return .get
        }
    }
    
    var url: String {
        switch self{
        case .lookUpProductList(page: let page, contentType: _):
            return "\(NetworkManager.baseUrl)/items/\(page)"
        case .lookUpProduct(id: let id, contentType: _):
            return "\(NetworkManager.baseUrl)/items/\(id)"
        }
    }
    
    var param: [String : String?]? {
        switch self {
        case .lookUpProductList:
            return nil
        case .lookUpProduct:
            return nil
        }
    }
    
    var mediaFile: [Media]? {
        switch self {
        case .lookUpProduct:
            return nil
        case .lookUpProductList:
            return nil
        }
    }
}
