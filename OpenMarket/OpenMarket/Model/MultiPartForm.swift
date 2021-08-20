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
    
    var description: String {
        switch self {
        case .boundary:
            return "Boundary\(UUID().uuidString)"
        case .httpHeader:
            return "multipart/form-data; boundary=\(Self.boundary.description)"
        case .httpHeaderField:
            return "Content-Type"
        case .contentDisposition:
            return "Content-Disposition: form-data; name="
        }
    }
    static func creatHTTPBody(parameters: HTTPBodyParameter?, media: [Media]?, boundary: MultiPartForm, contentDisposition: MultiPartForm) -> Data? {
        let lineBreak = "\r\n"
        var body = Data()
        if let parameters = parameters {
            for (key,value) in parameters {
                body.append(boundary.description + lineBreak)
                body.append("\(contentDisposition.description)\"\(key)\"\(lineBreak+lineBreak)")
                body.append("\(value)\(lineBreak)")
            }
        }
        if let media = media {
            for image in media {
                var image = image
                body.append(boundary.description + lineBreak)
                body.append("\(contentDisposition.description)\"\(image.key)\"; filename=\"\(image.fileName)\"\(lineBreak)")
                image.mimeType = .png
                body.append("\(MultiPartForm.httpHeaderField.description): \(image.mimeType.rawValue + lineBreak + lineBreak)")
                body.append(image.imageData)
                body.append(lineBreak)
            }
        }
        body.append("--\(boundary)--\(lineBreak)")
        return body
    }
}
