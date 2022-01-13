//
//  NetworkConstant.swift
//  OpenMarket
//
//  Created by Ari on 2022/01/04.
//

import Foundation

enum APIAddress {
    static let baseURL = "https://market-training.yagom-academy.kr/api/products"
    case products(page: UInt, itemsPerPage: UInt)
    case product(id: UInt)
    case register
    case secret(id: UInt, secret: String)
    case secretSearch(id: UInt)
    case delete(id: UInt, secret: String)
    
    var url: URL? {
        switch self {
        case .products(let page, let itemsPerPage):
            return URL(string: APIAddress.baseURL + "?page_no=\(page)" + "&items_per_page=\(itemsPerPage)")
        case .product(let id):
            return URL(string: APIAddress.baseURL + "/\(id)")
        case .register:
            return URL(string: APIAddress.baseURL)
        case .secret(let id, let secret):
            return URL(string: APIAddress.baseURL + "/\(id)" + "/\(secret)")
        case .secretSearch(let id):
            return URL(string: APIAddress.baseURL + "/\(id)/secret")
        case .delete(let id, let secret):
            return URL(string: APIAddress.baseURL + "/\(id)" + "/\(secret)")
        }
    }
}
