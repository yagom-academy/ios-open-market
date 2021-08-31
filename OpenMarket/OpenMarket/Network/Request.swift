//
//  Request.swift
//  OpenMarket
//
//  Created by tae hoon park on 2021/08/31.
//

import Foundation

struct Request {
    typealias ParamType = [String: Any]
    private let boundary: String = "Boundary-\(UUID().uuidString)"
    
    func createRequest() {
        
    }
    
    
    
    private func createBody(params: ParamType?, image: [imageData]?) -> Data {
        var body = Data()

        let lineBreak = "\r\n"
        
        if let parameters = params {
            for (key, value) in parameters {
                body.append("==\(boundary)\(lineBreak)")
                body.append("Content-Disposition: form-data; name=\"\(key)\"\(lineBreak + lineBreak)")
                body.append("\(value)\(lineBreak)")
            }
        }
        
        if let image = image {
            for photo in image {
                body.append("==\(boundary)\(lineBreak)")
                body.append("Content-Disposition: form-data; name=\"\(photo.key)\"; filename=\"\(photo.filename)\"\(lineBreak)")
                body.append("Content-Type: \(photo.mimeType)\(lineBreak + lineBreak)")
                body.append(photo.data)
                body.append(lineBreak)
            }
        }
        
        body.append("--\(boundary)--\(lineBreak)")
        
        return body
    }
}
