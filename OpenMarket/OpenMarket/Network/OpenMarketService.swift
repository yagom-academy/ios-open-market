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
    case updateProduct(sellerID: String, productID: String, body: Data)
    case showProductSecret(sellerID: String, sellerPW: String, productID: String)
    case deleteProduct(sellerID: String, productID: String, productSecret: String)
    case showProductDetail(productID: String)
    case showProductPage(pageNumber: String, itemsPerPage: String)
}

extension OpenMarketService {
    var urlRequest: URLRequest? {
        switch self {
        case .checkHealth:
            return HealthCheckerRequest().urlRequest
        case .showProductPage(let pageNumber, let itemsPerPage):
            return ShowProductPageRequest(pageNumber: pageNumber, itemsPerPage: itemsPerPage).urlRequest
        case .showProductDetail(let productID):
            return ShowProductDetailRequest(productID: productID).urlRequest
        case .createProduct(let sellerID, let params, let images):
            return CreateProductRequest(header: ["identifier":  sellerID], params: params, images: images).urlRequest
        case .updateProduct(let sellerID, let productID, let body):
            let header = ["identifier": sellerID]
            return UpdateProductRequest(productID: productID, header: header, body: body).urlRequest
        case .showProductSecret(let sellerID, let sellerPW, let productID):
            let header = ["identifier": sellerID]
            let body = ["secret": sellerPW]
            return ShowProductSecretRequest(productID: productID, header: header, body: body).urlRequest
        case .deleteProduct(let sellerID, let productID, let productSecret):
            let header = ["identifier": sellerID]
            return DeleteProductRequest(productID: productID, productSecret: productSecret, header: header).urlRequest
        }
    }
}
