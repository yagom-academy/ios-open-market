//
//  OpenMarketService.swift
//  OpenMarket
//
//  Created by Jae-hoon Sim on 2022/01/04.
//

import Foundation

enum OpenMarketService {
    case checkHealth
    case createProduct(id: String, params: CreateProductRequestParams, images: Data)
    case updateProduct
    case showProductSecret
    case deleteProduct
    case showProductDetail
    case showPage
}

extension OpenMarketService {
    var urlRequest: URLRequest {
        URLRequest(url: URL(string: "")!)
    }
}
