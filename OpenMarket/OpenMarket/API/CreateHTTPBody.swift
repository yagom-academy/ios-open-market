//
//  CreateHTTPBody.swift
//  OpenMarket
//
//  Created by 이예원 on 2021/09/06.
//

import UIKit

struct CreateHTTPBody {
    
    let boundary = APIManager.shared.generateBoundary()
    
    func createHTTPBody(parameters: HTTPBodyParameter?, media: [Media]?) -> Data {
        let lineBreak = "\r\n"
        let lastBoundary = "--\(boundary)--\(lineBreak)"
        let contentDisposition = "Content-Disposition: form-data; name="
        let contentType = "Content-Type: "
        
        var body = Data()
        
        if let parameters = parameters {
            for (key, value) in parameters {
                body.append("--\(boundary)\(lineBreak)")
                body.append("\(contentDisposition)\"\(key)\"\(lineBreak)\(lineBreak)")
                body.append("\(value)\(lineBreak)")
            }
        }
        
        if let media = media {
            for image in media {
                body.append("--\(boundary)\(lineBreak)")
                body.append("\(contentDisposition)\"\(image.key)\"; filename=\"\(image.fileName)\"\(lineBreak)")
                body.append("\(contentType) \(image.mimeType)\(lineBreak)\(lineBreak)")
                body.append(image.imageData)
                body.append(lineBreak)
            }
        }
        body.append(lastBoundary)
        return body
    }
}

extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}
