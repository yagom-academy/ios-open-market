//
//  NetworkConstant.swift
//  OpenMarket
//
//  Created by Ari on 2022/01/04.
//

import Foundation

enum Address {
    static let baseURL = "https://market-training.yagom-academy.kr/api/products"
    case products(page: UInt, itemsPerPage: UInt)
    case product(id: UInt)
    case register
    case secret(id: UInt, secret: String)
    case delete(id: UInt, secret: String)
    
    var url: URL? {
        switch self {
        case .products(let page, let itemsPerPage):
            return URL(string: Address.baseURL + "?page-no=\(page)" + "&items-per-page=\(itemsPerPage)")
        case .product(let id):
            return URL(string: Address.baseURL + "/\(id)")
        case .register:
            return URL(string: Address.baseURL)
        case .secret(let id, let secret):
            return URL(string: Address.baseURL + "/\(id)" + "/\(secret)")
        case .delete(let id, let secret):
            return URL(string: Address.baseURL + "/\(id)" + "/\(secret)")
        }
    }
}
