//
//  NetworkConstant.swift
//  OpenMarket
//
//  Created by Ari on 2022/01/04.
//

import Foundation

enum NetworkConstant {
    static let baseURL = "https://market-training.yagom-academy.kr/api/products"
    case products(page: UInt, itemsPerPage: UInt)
    case product(id: UInt)
    case registrate
    case secret(id: UInt, secret: String)
    case delete(id: UInt, secret: String)
    
    var url: URL? {
        switch self {
        case .products(let page, let itemsPerPage):
            return URL(string: NetworkConstant.baseURL + "?page-no=\(page)" + "&items-per-page=\(itemsPerPage)")
        case .product(let id):
            return URL(string: NetworkConstant.baseURL + "/\(id)")
        case .registrate:
            return URL(string: NetworkConstant.baseURL)
        case .secret(let id, let secret):
            return URL(string: NetworkConstant.baseURL + "/\(id)" + "/\(secret)")
        case .delete(let id, let secret):
            return URL(string: NetworkConstant.baseURL + "/\(id)" + "/\(secret)")
        }
    }
    
    enum HTTPMethod: String {
        case get = "GET"
        case post = "POST"
        case patch = "PATCH"
        case delete = "DELETE"
    }
}
