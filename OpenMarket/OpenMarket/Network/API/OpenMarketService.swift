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
    case showProductSecret(sellerID: String, sellerPW: String, productID: Int)
    case deleteProduct
    case showProductDetail(productID: Int)
    case showPage(pageNumber: Int, itemsPerPage: Int)
}

extension OpenMarketService {
    var baseURL: String {
        return "https://market-training.yagom-academy.kr"
    }
    
    var urlRequest: URLRequest? {
        switch self {
        case .checkHealth, .showPage, .showProductDetail:
            guard let url = URL(string: baseURL + self.path) else { return nil }
            var request = URLRequest(url: url)
            request.httpMethod = self.method
            return request
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
        case .showProductSecret(let sellerID, let sellerPW, _):
            guard let url = URL(string: baseURL + self.path) else { return nil }
            var request = URLRequest(url: url)
            request.httpMethod = self.method
            request.addValue(sellerID, forHTTPHeaderField: "identifier")
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = "{\"secret\": \"\(sellerPW)\"}".data(using: .utf8)
            return request
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
        case .showProductSecret(_, _, let productID):
            return "/api/products/\(productID)/secret"
        case .deleteProduct:
            return ""
        case .showProductDetail(let productID):
            return "/api/products/\(productID)"
        case .showPage(let pageNumber, let itemsPerPage):
            return "/api/products?page_no=\(pageNumber)&items_per_page=\(itemsPerPage)"
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
