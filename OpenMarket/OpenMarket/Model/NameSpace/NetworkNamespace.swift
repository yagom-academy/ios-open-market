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
    case identifier
    case passwordKey
    case passwordValue
    
    var name: String {
        switch self {
        case .get:
            return "GET"
        case .post:
            return "POST"
        case .patch:
            return "PATCH"
        case .del:
            return "DELETE"
        case .url:
            return "https://market-training.yagom-academy.kr/api/products"
        case .identifier:
            return "d1fb22fc-0335-11ed-9676-3bb3eb48793a"
        case .passwordKey:
            return "secret"
        case .passwordValue:
            return "lP8VFiBqGI"
        }
    }
}
