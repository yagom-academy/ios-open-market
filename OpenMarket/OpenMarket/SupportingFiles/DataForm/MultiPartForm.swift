//
//  MultiPartForm.swift
//  OpenMarket
//
//  Created by Luyan, Ellen on 2021/08/20.
//

import Foundation

struct MultiPartForm: DataForm {
    private let data: [String: Any]
    private let images: [Image]?
    private let boundary: String = "Boundary-\(UUID().uuidString)"
    
    var contentType: String {
        return "multipart/form-data; boundary=\(boundary)"
    }
    
    init(data: [String: Any], images: [Image]?) {
        self.data = data
        self.images = images
    }
    
    func createBody() throws -> Data? {
        let lineBreak = "\r\n"
        var body = Data()
        
        for (key, value) in self.data {
            body.append("--\(boundary + lineBreak)")
            body.append("Content-Disposition: form-data; name=\"\(key)\"\(lineBreak + lineBreak)")
            body.append("\(value)\(lineBreak)")
        }
        
        if let images = self.images {
            for image in images {
                body.append("--\(boundary + lineBreak)")
                body.append("Content-Disposition: form-data; name=\"\(image.key)\(lineBreak)")
                body.append("Content-Type: \(image.mimeType + lineBreak + lineBreak)")
                body.append(image.data)
                body.append(lineBreak)
            }
        }
        body.append("--\(boundary)--\(lineBreak)")
        return body
    }
}

