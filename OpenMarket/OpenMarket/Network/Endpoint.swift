//  OpenMarketApi.swift
//  OpenMarket
//  Created by SummerCat & Bella on 2022/11/18.

import Foundation

enum Endpoint {
    case healthChecker
    case fetchProductList(pageNumber: Int = 1, itemsPerPage: Int = 20)
    case fetchProductDetail(id: Product.ID)
    case registerProduct
}

extension Endpoint {
    var baseURL: String {
        return "https://openmarket.yagom-academy.kr"
    }
    
    var path: String {
        switch self {
        case .healthChecker:
            return "/healthChecker"
        case .fetchProductList(_, _):
            return "/api/products"
        case .fetchProductDetail(id: let id):
            return "/api/products/\(id)"
        case .registerProduct:
            return "/api/products"
        }
    }
    
    var queries: [URLQueryItem] {
        switch self {
        case .fetchProductList(pageNumber: let pageNumber, itemsPerPage: let itemsPerPage):
            var queryParameters: [URLQueryItem] = []
            queryParameters.append(URLQueryItem(name: "page_no", value: "\(pageNumber)"))
            queryParameters.append(URLQueryItem(name: "items_per_page", value: "\(itemsPerPage)"))
            return queryParameters
        default:
            return []
        }
    }
    
    func createURLRequest(httpMethod: HTTPMethod) -> URLRequest? {
        guard var components = URLComponents(string: self.baseURL) else { return nil }
        components.path = path
        components.queryItems = self.queries
        
        guard let url = components.url else { return nil }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = httpMethod.rawValue
        
        return urlRequest
    }
}
