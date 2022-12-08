//
//  OpenMarketAPI.swift
//  OpenMarket
//
//  Created by Ayaan, junho on 2022/12/02.
//

import UIKit.UIImage

enum OpenMarketAPI: Requestable {
    case checkHealth
    case fetchPage(pageNumber: Int, productsPerPage: Int)
    case fetchProduct(productNumber: Int)
    case registration(product: ProductToRequest, images: [UIImage], boundary: String = UUID().uuidString)
    case update(product: ProductToRequest)
    case inquiryDeregistrationURI(productId: Int)
    case deregistration(URI: String)
    
    var path: String {
        switch self {
        case .checkHealth:
            return "/healthChecker"
        case .fetchPage(let pageNumber, let productsPerPage):
            return "/api/products?page_no=\(pageNumber)&items_per_page=\(productsPerPage)"
        case .fetchProduct(let productNumber):
            return "/api/products/\(productNumber)"
        case .registration:
            return "/api/products"
        case .update(let product):
            return "/api/products/\(product.id)"
        case .inquiryDeregistrationURI(let productId):
            return "/api/products/\(productId)/archived"
        case .deregistration(let URI):
            return "/api/products/\(URI)"
        }
    }
    var method: HttpMethod {
        switch self {
        case .checkHealth:
            return .get
        case .fetchPage:
            return .get
        case .fetchProduct:
            return .get
        case .registration:
            return .post
        case .update:
            return .patch
        case .inquiryDeregistrationURI:
            return .post
        case .deregistration:
            return .delete
        }
    }
    var headers: [String : String] {
        switch self {
        case .checkHealth:
            return [:]
        case .fetchPage:
            return [:]
        case .fetchProduct:
            return [:]
        case .registration(_, _, let boundary):
            return ["identifier": "ecae4d3d-6941-11ed-a917-59a39ea07e01", "Content-Type": "multipart/form-data; boundary=\(boundary)"]
        case .update:
            return ["identifier": "ecae4d3d-6941-11ed-a917-59a39ea07e01"]
        case .inquiryDeregistrationURI:
            return ["identifier": "ecae4d3d-6941-11ed-a917-59a39ea07e01"]
        case .deregistration:
            return ["identifier": "ecae4d3d-6941-11ed-a917-59a39ea07e01"]
        }
    }
}
