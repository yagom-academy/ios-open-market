//
//  APIRequest.swift
//  OpenMarket
//
//  Created by groot, bard on 2022/07/12.
//

import Foundation

enum HTTPMethod {
    case get
    case post
    case delete
    case patch
    case put
    
    var name: String {
        switch self {
        case .get:
            return "GET"
        case .post:
            return "POST"
        case .delete:
            return "DELETE"
        case .patch:
            return "PATCH"
        case .put:
            return "PUT"
        }
    }
}

enum URLHost {
    case openMarket
    
    var url: String {
        switch self {
        case .openMarket:
            return "https://market-training.yagom-academy.kr"
        }
    }
}

enum URLAdditionalPath {
    case healthChecker
    case product
    
    var value: String {
        switch self {
        case .healthChecker:
            return "/healthChecker"
        case .product:
            return "/api/products"
        }
    }
    
    var mockFileName: String {
        switch self {
        case .healthChecker:
            return ""
        case .product:
            return "MockData"
        }
    }
}

protocol APIRequest {
    var method: HTTPMethod { get }
    var baseURL: String { get }
    var headers: [String: String]? { get }
    var query: [String: String]? { get }
    var body: [String: Data]? { get }
    var boundary: String? { get }
    var path: String? { get }
}
extension APIRequest {
    var url: URL? {
        var component = URLComponents(string: self.baseURL)
        component?.queryItems = query?.reduce([URLQueryItem]()) {
            $0 + [URLQueryItem(name: $1.key, value: $1.value)]
        }
        
        return component?.url
    }
    
    var urlRequest: URLRequest? {
        guard let url = url else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = method.name
        request.httpBody = createRequestBody()
        self.headers?.forEach { request.addValue($0.value, forHTTPHeaderField: $0.key) }
        
        return request
    }
    
    private func createRequestBody() -> Data? {
        guard let params = body?["params"],
              let paramsData = createMultipartformDataParams(params: params)
        else { return nil }
        guard let images = body?["images"],
              let imagesData = createMultipartformDataImages(images: images)
        else { return nil }
        
        var requestBody = Data()
        requestBody.append(paramsData)
        requestBody.append(imagesData)
        
        return requestBody
    }
    
    private func createMultipartformDataParams(params: Data) -> Data? {
        guard let boundary = self.boundary else { return nil }
        let lineBreak = "\r\n"
        var paramsBody = Data()
        
        paramsBody.append("\(lineBreak)--\(boundary + lineBreak)" .data(using: .utf8)!)
        paramsBody.append("Content-Disposition: form-data; name=\"params\"\(lineBreak)" .data(using: .utf8)!)
        paramsBody.append("Content-Type: application/json \(lineBreak + lineBreak)" .data(using: .utf8)!)
        paramsBody.append(params)
        
        return paramsBody
    }
    
    private func createMultipartformDataImages(images: Data) -> Data? {
        guard let boundary = self.boundary else { return nil }
        let lineBreak = "\r\n"
        let fileName = String(decoding: images, as: UTF8.self)
        var imageBody = Data()
        
        imageBody.append("\(lineBreak)--\(boundary + lineBreak)" .data(using: .utf8)!)
        imageBody.append("Content-Disposition: form-data; name=\"images\"; filename=\"\(fileName)\"\(lineBreak)" .data(using: .utf8)!)
        imageBody.append("Content-Type: image/jpeg \(lineBreak + lineBreak)" .data(using: .utf8)!)
        imageBody.append(images)
        imageBody.append("\(lineBreak)--\(boundary)--\(lineBreak)" .data(using: .utf8)!)
        
        return imageBody
    }
}
