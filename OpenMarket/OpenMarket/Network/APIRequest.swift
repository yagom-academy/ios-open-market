//
//  APIRequest.swift
//  OpenMarket
//
//  Created by groot, bard on 2022/07/12.
//

import Foundation
import UIKit.UIImage

enum HTTPMethod {
    case get
    case post
    case delete
    case patch
    
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
        }
    }
}

protocol APIRequest {
    var baseURL: String { get }
    var path: String? { get }
    var method: HTTPMethod { get }
    var headers: [String: String]? { get }
    var query: [String: String]? { get }
    var body: Data? { get }
}

extension APIRequest {
    var url: URL? {
        var component = URLComponents(string: self.baseURL + (self.path ?? ""))
        component?.queryItems = query?.reduce([URLQueryItem]()) {
            $0 + [URLQueryItem(name: $1.key, value: $1.value)]
        }
        
        return component?.url
    }
    
    var urlRequest: URLRequest? {
        guard let url = url else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = method.name
        request.httpBody = body
        self.headers?.forEach { request.addValue($0.value, forHTTPHeaderField: $0.key) }
        
        return request
    }

    func createMultiPartFormBody(boundary: String, paramsData: Data, images: [Data]) -> Data {
        let lineBreak = "\r\n"
        var requestBody = Data()
        
        requestBody.append(createMultipartformDataParams(boundary: boundary, data: paramsData))
        images.forEach {
            requestBody.append(createMultipartformDataImages(boundary: boundary, image: $0))
        }
        requestBody.append("\(lineBreak)--\(boundary)--\(lineBreak)")
        
        return requestBody
    }
    
    private func createMultipartformDataParams(boundary: String, data: Data) -> Data {
        let lineBreak = "\r\n"
        var paramsBody = Data()
        
        paramsBody.append("\(lineBreak)--\(boundary + lineBreak)")
        paramsBody.append("Content-Disposition: form-data; name=\"params\"\(lineBreak)")
        paramsBody.append("Content-Type: application/json \(lineBreak + lineBreak)")
        paramsBody.append(data)
        
        return paramsBody
    }
    
    private func createMultipartformDataImages(boundary: String, image: Data) -> Data {
        let lineBreak = "\r\n"
        var imageBody = Data()
        
        imageBody.append("\(lineBreak)--\(boundary + lineBreak)")
        imageBody.append("Content-Disposition: form-data; name=\"images\"; filename=\"\(boundary).png\"\(lineBreak)")
        imageBody.append("Content-Type: image/png \(lineBreak + lineBreak)")
        imageBody.append(image)
        
        return imageBody
    }
}
