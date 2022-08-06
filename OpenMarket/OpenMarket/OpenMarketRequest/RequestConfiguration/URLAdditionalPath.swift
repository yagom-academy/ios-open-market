//
//  URLAdditionalPath.swift
//  OpenMarket
//
//  Created by groot, bard on 2022/08/05.
//

enum URLAdditionalPath {
    case healthChecker
    case product
    
    var value: String {
        switch self {
        case .healthChecker:
            return "/healthChecker"
        case .product:
            return "/api/products"
        }
    }
    
    var mockFileName: String {
        switch self {
        case .healthChecker:
            return ""
        case .product:
            return "MockData"
        }
    }
}
