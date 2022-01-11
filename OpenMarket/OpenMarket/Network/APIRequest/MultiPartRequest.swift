//
//  MultiPartRequest.swift
//  OpenMarket
//
//  Created by Jae-hoon Sim on 2022/01/09.
//

import Foundation

protocol MultiPartRequest: APIRequest {
    
    var data: [MultiPartFileType] { get }
    
}

extension MultiPartRequest {
    
    var urlRequest: URLRequest? {
        guard let url = URL(string: finalURL) else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = self.method.decription
        header?.forEach { request.addValue($1, forHTTPHeaderField: $0) }
        let boundary = UUID().uuidString
        request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.httpBody = makeMultiPartBody(data, boundary: boundary)
        return request
    }
    
    private func makeMultiPartBody(_ dataArray: [MultiPartFileType], boundary: String) -> Data {
        let data = dataArray.reduce(NSMutableData()) {
            switch $1 {
            case .json(let name, let data):
                $0.appendJSON(name: name, data: data, boundary: boundary)
            case .image(let name, let images):
                $0.appendImage(name: name, images: images, boundary: boundary)
            }
            return $0
        }
        data.append("--\(boundary)--\r\n")
        return data as Data
    }
    
}

enum MultiPartFileType {
    
    case json(name: String, data: Data)
    case image(name: String, images: [Image])
    
}

private extension NSMutableData {
    
    func appendJSON(name: String, data: Data, boundary: String) {
        self.append("--\(boundary)\r\n")
        self.append("Content-Disposition: form-data; name=\"\(name)\"\r\n")
        self.append("Content-Type: application/json\r\n")
        self.append("\r\n")
        self.append(data)
        self.append("\r\n")
    }

    func appendImage(name:String, images: [Image], boundary: String) {
        for image in images {
            self.append("--\(boundary)\r\n")
            let fileName = "filename=\"\(UUID().uuidString).\(image.type)"
            let contentHeader = "Content-Disposition: form-data; name=\"\(name)\"; \(fileName)\"\r\n"
            self.append(contentHeader)
            self.append("Content-Type: image/\(image.type)\r\n")
            self.append("\r\n")
            self.append(image.data)
            self.append("\r\n")
        }
    }
    
}
