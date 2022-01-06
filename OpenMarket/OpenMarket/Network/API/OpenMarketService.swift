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
        case .createProduct(let sellerID, let params, let images):
            guard let url = URL(string: baseURL + self.path) else { return nil }
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = self.method
            urlRequest.addValue(sellerID, forHTTPHeaderField: "identifier")
            urlRequest.addValue("multipart/form-data; boundary=----WebKitFormBoundary7MA4YWxkTrZu0gW", forHTTPHeaderField: "Content-Type")
            let body = NSMutableData()
            makeBody(target: body, name: "params", data: params)
            makeBodyImage(target: body, name: "images", images: images)
            body.append("------WebKitFormBoundary7MA4YWxkTrZu0gW--\r\n")
            urlRequest.httpBody = body as Data
            return urlRequest
        case .updateProduct(let sellerID, _, let body):
            print(self.path)
            guard let url = URL(string: baseURL + self.path) else { return nil }
            var request = URLRequest(url: url)
            request.httpMethod = self.method
            request.addValue(sellerID, forHTTPHeaderField: "identifier")
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = body
            return request
        case .showProductSecret(let sellerID, let sellerPW, _):
            guard let url = URL(string: baseURL + self.path) else { return nil }
            var request = URLRequest(url: url)
            request.httpMethod = self.method
            request.addValue(sellerID, forHTTPHeaderField: "identifier")
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = "{\"secret\": \"\(sellerPW)\"}".data(using: .utf8)
            return request
        case .deleteProduct(let sellerID, _, _):
            guard let url = URL(string: baseURL + self.path) else { return nil }
            var request = URLRequest(url: url)
            request.httpMethod = self.method
            request.addValue(sellerID, forHTTPHeaderField: "identifier")
            return request
        }
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
        case .showPage(let pageNumber, let itemsPerPage):
            return "/api/products?page_no=\(pageNumber)&items_per_page=\(itemsPerPage)"
        }
    }
    
    var method: String {
        switch self {
        case .checkHealth, .showProductDetail, .showPage:
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
    
    func makeBody(target: NSMutableData, name:String, data: Data) {
        target.append("------WebKitFormBoundary7MA4YWxkTrZu0gW\r\n")
        target.append("Content-Disposition: form-data; name=\"\(name)\"\r\n")
        target.append("Content-Type: application/json\r\n")
        target.append("\r\n")
        target.append(data)
        target.append("\r\n")
    }

    func makeBodyImage(target: NSMutableData, name:String, images: [Data]) {
        for image in images {
            target.append("------WebKitFormBoundary7MA4YWxkTrZu0gW\r\n")
            target.append("Content-Disposition: form-data; name=\"\(name)\"; filename=\"\(UUID().uuidString).png\"\r\n")
            target.append("Content-Type: image/png\r\n")
            target.append("\r\n")
            target.append(image)
            target.append("\r\n")
        }
    }
    
}

extension NSMutableData {
    
    func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            self.append(data)
        }
    }
    
}
