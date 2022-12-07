//
//  MultipartFormData.swift
//  OpenMarket
//
//  Created by Gundy, Wonbi on 2022/12/07.
//

import Foundation

struct MultipartFormData {
    private let boundary: String = "----\(UUID().uuidString)"
    private(set) var header: [String: String] = [:]
    private(set) var body: Data = Data()
    
    init() {
        header["Content-Type"] = "multipart/form-data; boundary=\(boundary)"
    }
    
    mutating func appendHeader(key: String, value: String) {
        header[key] = value
    }
    
    func fetchHTTPHeader() -> [String: String] {
        
        return header
    }
    
    mutating func appendBody(name: String? = nil, fileName: String? = nil, contentType: String, data: Data) {
        let lineBreak = "\r\n"
        
        body.append("--" + boundary + lineBreak, using: .utf8)
        if let fileName = fileName,
        let name = name {
            body.append("Content-Disposition:form-data; name=\"\(name)\"; filename=\"\(fileName)\"" + lineBreak, using: .utf8)
        } else if let name = name {
            body.append("Content-Disposition:form-data; name=\"\(name)\"" + lineBreak, using: .utf8)
        } else {
            body.append("Content-Disposition:form-data" + lineBreak, using: .utf8)
        }
        body.append("Content-Type: \(contentType)" + lineBreak, using: .utf8)
        body.append(lineBreak, using: .utf8)
        body.append(data)
        body.append(lineBreak, using: .utf8)
    }
    
    func fetchHTTPBody() -> Data {
        var body = self.body
        body.append("--" + boundary + "--", using: .utf8)
        
        return body
    }
}
