//
//  OpenMarketService.swift
//  OpenMarket
//
//  Created by Jae-hoon Sim on 2022/01/04.
//

import Foundation

enum OpenMarketService {
    case checkHealth
    case createProduct(id: String, params: String, images: [Data])
    case updateProduct
    case showProductSecret
    case deleteProduct
    case showProductDetail
    case showPage
}

extension OpenMarketService {
    var baseURL: String {
        return "https://market-training.yagom-academy.kr"
    }
    
    var urlRequest: URLRequest? {
        switch self {
        case .checkHealth, .showPage, .showProductDetail:
            return URLRequest(url: URL(string: "")!)
        case .createProduct(let id, let params, let images):
            guard let url = URL(string: self.baseURL + self.path) else {
                return nil
            }
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = self.method
            urlRequest.addValue(id, forHTTPHeaderField: "identifier")
            urlRequest.addValue("multipart/form-data", forHTTPHeaderField: "Content-Type")
            
            return urlRequest
        case .updateProduct:
            return URLRequest(url: URL(string: "")!)
        case .showProductSecret:
            return URLRequest(url: URL(string: "")!)
        case .deleteProduct:
            return URLRequest(url: URL(string: "")!)
        }
    }
    
    var path: String {
        switch self {
        case .checkHealth:
            return "/healthChecker"
        case .createProduct:
            return "/api/products"
        case .updateProduct:
            return ""
        case .showProductSecret:
            return ""
        case .deleteProduct:
            return ""
        case .showProductDetail:
            return ""
        case .showPage:
            return ""
        }
    }
    
    var method: String {
        switch self {
        case .checkHealth, .showProductDetail, .showPage:
            return "GET"
        case .createProduct:
            return "POST"
        case .updateProduct:
            return "PATCH"
        case .showProductSecret:
            return "POST"
        case .deleteProduct:
            return "DELETE"
        }
    }
}
