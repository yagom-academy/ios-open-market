//
//  MultipartFormData.swift
//  OpenMarket
//
//  Created by 임성민 on 2021/02/02.
//

import Foundation

protocol MultipartFormData {
    var parameters: [String: String]? { get set }
    var medias: [Media]? { get set }
    func generateBoundary() -> String
    func makeDataBody(boundary: String) -> Data?
}

extension MultipartFormData {
    func generateBoundary() -> String {
        return "Boundary-\(NSUUID().uuidString)"
    }
    
    func makeDataBody(boundary: String) -> Data? {
        guard let lineBreak = "\r\n".data(using: .utf8),
              let boundaryPrefix = "--\(boundary)\r\n".data(using: .utf8),
              let contentDisposition = "Content-Disposition: form-data; ".data(using: .utf8) else {
            return nil
        }
        var body = Data()
        if let parameters = parameters {
            for (key, value) in parameters {
                guard let dataName = "name=\"\(key)\"".data(using: .utf8),
                      let value = "\(value)".data(using: .utf8) else {
                    return nil
                }
                body.append(boundaryPrefix)
                body.append(contentDisposition)
                body.append(dataName)
                body.append(lineBreak)
                body.append(lineBreak)
                body.append(value)
                body.append(lineBreak)
            }
        }
        if let medias = medias {
            for m in medias {
                guard let dataName = "name=\"\(m.key)\"; ".data(using: .utf8),
                      let fileName = "filename=\"\(m.fileName)\"".data(using: .utf8),
                      let contentType = "Content-Type: \(m.mimeType)".data(using: .utf8) else {
                    return nil
                }
                body.append(boundaryPrefix)
                body.append(contentDisposition)
                body.append(dataName)
                body.append(fileName)
                body.append(lineBreak)
                body.append(contentType)
                body.append(lineBreak)
                body.append(lineBreak)
                body.append(m.data)
                body.append(lineBreak)
            }
        }
        body.append(boundaryPrefix)
        return body
    }
}
