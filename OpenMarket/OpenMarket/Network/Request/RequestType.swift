//
//  APIAddress.swift
//  OpenMarket
//
//  Created by 고은 on 2022/01/07.
//

import Foundation

enum RequestType {
    static let apiHost = "https://market-training.yagom-academy.kr"
    
    case productModification(productID: Int)
    case productDelete(productID: Int, productSecretKey: Int)
    
    func url(type: RequestType) -> String {
        switch type {
        case .productModification(let productID):
            return "\(RequestType.apiHost)/api/products/\(productID)"
        case .productDelete(let productID, let productSecretKey):
            return "\(RequestType.apiHost)/api/products/\(productID)/\(productSecretKey)"
        }
    }
}
