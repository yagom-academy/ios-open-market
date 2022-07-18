//
//  NetworkNamespace.swift
//  OpenMarket
//
//  Created by unchain, hyeon2 on 2022/07/14.
//

enum NetworkNamespace: String {
    case get
    case post
    case patch
    case del
    case url
    
    var name: String {
        switch self {
        case .get:
            return "GET"
        case .post:
            return "POST"
        case .patch:
            return "PATCH"
        case .del:
            return "DEL"
        case .url:
            return "https://market-training.yagom-academy.kr/api/products"
        }
    }
}
