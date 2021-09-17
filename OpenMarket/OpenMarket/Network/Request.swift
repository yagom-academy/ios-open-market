//
//  Request.swift
//  OpenMarket
//
//  Created by tae hoon park on 2021/08/31.
//

import Foundation

struct Request {
    func createRequest(api: Requestable) throws -> URLRequest {
        guard let url = URL(string: api.url.path) else {
            throw NetworkError.invalidURL
        }
        var request = URLRequest(url: url)
        request.httpMethod = api.httpMethod.value
        request.setValue(api.contentType.format,
                         forHTTPHeaderField: ContentType.httpHeaderField)
        
        if let api = api as? DeleteAPI {
            guard let body = try? JSONEncoder().encode(api.password) else {
                throw ParsingError.encodingFailed
            }
            request.httpBody = body
        } else if let api = api as? RequestableWithMultipartForm {
            let body = createBody(params: api.parameter, image: api.image)
            request.httpBody = body
        }
        return request
    }
    
    private func createBody(params: [String: Any]?, image: [Media]?) -> Data {
        var body = Data()
        
        let lineBreak = "\r\n"
        let doubleLineBreak = "\r\n\r\n"
        
        if let parameters = params {
            for (key, value) in parameters {
                body.append("--\(Boundary.uuid)\(lineBreak)")
                body.append(
                    "Content-Disposition: form-data; name=\"\(key)\"\(doubleLineBreak)")
                body.append("\(value)\(lineBreak)")
            }
        }
        
        if let image = image {
            for photo in image {
                body.append("--\(Boundary.uuid)\(lineBreak)")
                body.append(
                    "Content-Disposition: form-data; name=\"\(photo.key)\"; filename=\"\(photo.fileName)\"\(lineBreak)")
                body.append("Content-Type: \(photo.mimeType)\(doubleLineBreak)")
                body.append(photo.data)
                body.append(lineBreak)
            }
        }
        
        body.append("--\(Boundary.uuid)--\(lineBreak)")
        
        return body
    }
}
