//
//  File.swift
//  OpenMarket
//
//  Created by 고은 on 2022/01/22.
//

import Foundation

enum PostType {
    case productRegistration
    case searchSecretIDForDelete(productID: Int)
    
    func url(type: PostType) -> String {
        switch type {
        case .productRegistration:
            return "\(RequestType.apiHost)/api/products"
        case .searchSecretIDForDelete(let productID):
            return "\(RequestType.apiHost)/api/products/\(productID)/secret"
        }
    }
}
