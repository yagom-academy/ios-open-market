//  OpenMarketApi.swift
//  OpenMarket
//  Created by SummerCat & Bella on 2022/11/18.

enum OpenMarketAPI {
    case healthChecker
    case productList(pageNumber: Int, itemsPerPage: Int)
    case product(id: Int)
}

extension OpenMarketAPI: Endpointable {
    var path: String {
        switch self {
        case .healthChecker:
            return "/healthChecker"
        case .productList(_, _):
            return "/api/products"
        case .product(id: let id):
            return "/api/products/\(id)"
        }
    }
    
    var queries: [String : String] {
        switch self {
        case .productList(pageNumber: let pageNumber, itemsPerPage: let itemsPerPage):
            return ["page_no": "\(pageNumber)", "items_per_page": "\(itemsPerPage)"]
        default:
            return [:]
        }
    }
}

