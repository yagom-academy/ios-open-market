//
//  MultiPartForm.swift
//  OpenMarket
//
//  Created by Luyan, Ellen on 2021/08/20.
//

import Foundation

struct MultiPartForm: DataForm {
    private let data: [String: Any]
    private let media: [Media]?
    private let boundary: String = "Boundary-\(UUID().uuidString)"
    
    init(data: [String: Any], media: [Media]?) {
        self.data = data
        self.media = media
    }
    
    var contentType: String {
        return "multipart/form-data; boundary=\(boundary)"
    }
    
    func createBody() throws -> Data? {
        let lineBreak = "\r\n"
        var body = Data()
        
        for (key, value) in self.data {
            body.append("--\(boundary + lineBreak)")
            body.append("Content-Disposition: form-data; name=\"\(key)\"\(lineBreak + lineBreak)")
            body.append("\(value)\(lineBreak)")
        }
        
        if let media = self.media {
            for photo in media {
                body.append("--\(boundary + lineBreak)")
                body.append("Content-Disposition: form-data; name=\"\(photo.key)\"; filename=\"\(photo.fileName)\"\(lineBreak)")
                body.append("Content-Type: \(photo.mimeType + lineBreak + lineBreak)")
                body.append(photo.data)
                body.append(lineBreak)
            }
        }
        body.append("--\(boundary)--\(lineBreak)")
        return body
    }
}

