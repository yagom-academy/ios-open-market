//
//  CreateProductRequest.swift
//  OpenMarket
//
//  Created by JeongTaek Han on 2022/01/07.
//

import Foundation

struct CreateProductRequest: POSTRequest {
    var header: [String : String]?
    var body: [String : Any]
    var path: String
    
    var params: Data
    var images: [Data]
    
    var urlRequest: URLRequest? {
        guard let url = URL(string: finalURL) else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = self.method
        header?.forEach { request.addValue($1, forHTTPHeaderField: $0) }
        let boundary = UUID().uuidString
        request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.httpBody = makeMultiPartBody(params: params, images: images, boundary: boundary)
        return request
    }
    
    init(header: [String: String], params: Data, images: [Data]) {
        self.path = "/api/products"
        self.header = header
        self.body = [:]
        self.params = params
        self.images = images
    }
    
}

extension CreateProductRequest {
    
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
