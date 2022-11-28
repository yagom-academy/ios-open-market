//  OpenMarketApi.swift
//  OpenMarket
//  Created by SummerCat & Bella on 2022/11/18.

enum OpenMarketAPI {
    case healthChecker
    case productList(pageNumber: Int)
    case product(id: Int)
}

extension OpenMarketAPI: Endpointable {
    var path: String {
        switch self {
        case .healthChecker:
            return "/healthChecker"
        case .productList(_):
            return "/api/products"
        case .product(id: let id):
            return "/api/products/\(id)"
        }
    }
    
    
    var queries: [String : String] {
        switch self {
        case .productList(pageNumber: let pageNumber):
            return ["page_no": "\(pageNumber)"]
        default:
            return [:]
        }
    }
}

