//
//  MultiPartForm.swift
//  OpenMarket
//
//  Created by 이예원 on 2021/08/20.
//

import Foundation

typealias HTTPBodyParameter = [String : Any]

enum MultiPartForm: CustomStringConvertible {
    case boundary
    case httpHeader
    case httpHeaderField
    case contentDisposition
    case lastBoundary
    
    var description: String {
        switch self {
        case .boundary:
            return "Boundary-\(UUID().uuidString)"
        case .httpHeader:
            return "multipart/form-data; boundary=\(Self.boundary.description)"
        case .httpHeaderField:
            return "Content-Type:"
        case .contentDisposition:
            return "Content-Disposition: form-data; name="
        case .lastBoundary:
            return "--\(Self.boundary.description)--\r\n"
        }
    }
    static func createHTTPBody(parameters: HTTPBodyParameter?, media: [Media]?) -> Data {
        let boundary = "Boundary-\(UUID().uuidString)"
        let lineBreak = "\r\n"
        let lastBoundary = "--\(boundary)--\(lineBreak)"
        let contentDisposition = "Content-Disposition: form-data; name="
        let contentType = "Content-Type: "
        
        var body = Data()
        
        if let parameters = parameters {
            for (key,value) in parameters {
                body.append("--\(boundary)\(lineBreak)")
                body.append("\(contentDisposition.description)\"\(key)\"\(lineBreak)\(lineBreak)")
                body.append("\(value)\(lineBreak)")
            }
        }
        
        if let media = media {
            for image in media {
                body.append("--\(boundary.description)\(lineBreak)")
                body.append("\(contentDisposition)\"\(image.key)\"; filename=\"\(image.fileName)\"\(lineBreak)")
                body.append("\(contentType)\(image.mimeType)\(lineBreak)\(lineBreak)")
                body.append(image.imageData)
                body.append(lineBreak)
            }
        }
        body.append(lastBoundary)
        return body
    }
}
