//
//  OpenMarketService.swift
//  OpenMarket
//
//  Created by Jae-hoon Sim on 2022/01/04.
//

import Foundation

enum OpenMarketService {
    case checkHealth
    case createProduct(sellerID: String, params: Data, images: [Data])
    case updateProduct(sellerID: String, productID: Int, body: Data)
    case showProductSecret(sellerID: String, sellerPW: String, productID: Int)
    case deleteProduct(sellerID: String, productID: Int, productSecret: String)
    case showProductDetail(productID: Int)
    case showProductPage(pageNumber: Int, itemsPerPage: Int)
}

extension OpenMarketService {
    var urlRequest: URLRequest? {
        guard let url = URL(string: finalURL) else { return nil }
        
        switch self {
        case .checkHealth, .showProductPage, .showProductDetail:
            return makeURLRequest(url: url, header: [:])
        case .createProduct(let sellerID, let params, let images):
            
        case .updateProduct(let sellerID, _, let body):
            var request = makeURLRequest(url: url, header: [
                "identifier": sellerID,
                "Content-Type": "application/json"
            ])
            request?.httpBody = body
            return request
        case .showProductSecret(let sellerID, let sellerPW, _):
            var request = makeURLRequest(url: url, header: [
                "identifier": sellerID,
                "Content-Type": "application/json"
            ])
            request?.httpBody = try? JSONEncoder().encode(["secret": sellerPW])
            return request
        case .deleteProduct(let sellerID, _, _):
            return makeURLRequest(url: url, header: ["identifier": sellerID])
        }
    }
}

extension OpenMarketService {
    
    var path: String {
        switch self {
        case .checkHealth:
            return "/healthChecker"
        case .createProduct:
            return "/api/products"
        case .updateProduct(_, let productID, _):
            return "/api/products/\(productID)"
        case .showProductSecret(_, _, let productID):
            return "/api/products/\(productID)/secret"
        case .deleteProduct(_, let productID, let productSecret):
            return "/api/products/\(productID)/\(productSecret)"
        case .showProductDetail(let productID):
            return "/api/products/\(productID)"
        case .showProductPage(let pageNumber, let itemsPerPage):
            return "/api/products?page_no=\(pageNumber)&items_per_page=\(itemsPerPage)"
        }
    }
    
}

extension OpenMarketService {
    
    
    
    
    
}
