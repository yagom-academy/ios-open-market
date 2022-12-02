//
//  OpenMarketAPI.swift
//  OpenMarket
//
//  Copyright (c) 2022 Minii All rights reserved.

import Foundation

enum OpenMarketAPI: APIType {
    case healthChecker
    case productsList(pageNumber: Int, rowCount: Int, searchValue: String = "")
    case productSearch(productId: Int)
    case addProduct(sendId: UUID, bodies: [HttpBody])
    
    var baseURL: String {
        return "https://openmarket.yagom-academy.kr"
    }
    
    var method: HTTPMethod {
        switch self {
        case .healthChecker, .productsList, .productSearch:
            return .GET
        case .addProduct:
            return .POST
        }
    }
    
    
    var path: String {
        switch self {
        case .healthChecker:
            return "/healthChecker"
        case .productsList(_, _, _):
            return "/api/products"
        case .productSearch(let productId):
            return "/api/products/\(productId)"
        case .addProduct(_, _):
            return "/api/products"
        }
    }
    
    var parameters: [String : String]? {
        switch self {
        case .productsList(let pageNumber, let rowCount, let searchValue):
            return [
                "page_no": pageNumber.description,
                "items_per_page": rowCount.description,
                "search_value": searchValue
            ]
        default:
            return nil
        }
    }
    
    var headers: [String : String] {
        switch self {
        case .addProduct(let id, _):
            return [
                "identifier": "5fcfb895-6942-11ed-a917-1385e44824d5",
                "Content-Type": "multipart/form-data; boundary=\(id.uuidString)"
            ]
        default:
            return [:]
        }
    }
    
    var body: Data {
        var value: Data = Data()
        switch self {
        case .addProduct(let id, let bodies):
            let boundary = "--\(id.uuidString)"
            guard let endBoundaryData = "\(boundary)--".data(using: .utf8) else {
                return value
            }
            bodies.forEach {
                value.append($0.createBody(boundary: boundary))
            }
            value.append(endBoundaryData)
            
            return value
        default:
            return Data()
        }
    }
    
    func generateURL() -> URL? {
        guard var baseComponents = URLComponents(string: baseURL) else {
            return nil
        }
        
        baseComponents.path = path
        
        if let parameters = parameters {
            baseComponents.queryItems = parameters.asParameters()
        }
        return baseComponents.url
    }
    
    func generateRequest() -> URLRequest? {
        guard let requestURL = generateURL() else {
            return nil
        }
        
        var request = URLRequest(url: requestURL)
        
        headers.forEach {
            request.setValue($0.value, forHTTPHeaderField: $0.key)
        }
        request.httpBody = body
        request.httpMethod = method.rawValue
        
        return request
    }
}
