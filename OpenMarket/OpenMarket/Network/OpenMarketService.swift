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
            let boundary = UUID().uuidString
            var request = makeURLRequest(url: url, header: [
                "identifier": sellerID,
                "Content-Type": "multipart/form-data; boundary=\(boundary)"
            ])
            request?.httpBody = makeMultiPartBody(params: params, images: images, boundary: boundary)
            return request
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
    var finalURL: String {
        baseURL + path
    }
    
    var baseURL: String {
        return "https://market-training.yagom-academy.kr"
    }
    
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
    
    var method: String {
        switch self {
        case .checkHealth, .showProductDetail, .showProductPage:
            return "GET"
        case .createProduct, .showProductSecret:
            return "POST"
        case .updateProduct:
            return "PATCH"
        case .deleteProduct:
            return "DELETE"
        }
    }
}

extension OpenMarketService {
    
    private func makeURLRequest(url: URL, header: [String: String]) -> URLRequest? {
        var request = URLRequest(url: url)
        request.httpMethod = self.method
        header.forEach { request.addValue($1, forHTTPHeaderField: $0) }
        return request
    }
    
    private func configureBody(target: NSMutableData, name: String, data: Data, boundary: String) {
        target.append("--\(boundary)\r\n")
        target.append("Content-Disposition: form-data; name=\"\(name)\"\r\n")
        target.append("Content-Type: application/json\r\n")
        target.append("\r\n")
        target.append(data)
        target.append("\r\n")
    }

    private func configureBodyImage(target: NSMutableData, name:String, images: [Data], boundary: String) {
        for image in images {
            target.append("--\(boundary)\r\n")
            target.append("Content-Disposition: form-data; name=\"\(name)\"; filename=\"\(UUID().uuidString).png\"\r\n")
            target.append("Content-Type: image/png\r\n")
            target.append("\r\n")
            target.append(image)
            target.append("\r\n")
        }
        
    }
    
    private func makeMultiPartBody(params: Data, images: [Data], boundary: String) -> Data {
        let body = NSMutableData()
        configureBody(target: body, name: "params", data: params, boundary: boundary)
        configureBodyImage(target: body, name: "images", images: images, boundary: boundary)
        body.append("--\(boundary)--\r\n")
        return body as Data
    }
    
}
