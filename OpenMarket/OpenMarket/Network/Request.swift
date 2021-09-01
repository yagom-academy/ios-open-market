//
//  Request.swift
//  OpenMarket
//
//  Created by tae hoon park on 2021/08/31.
//

import Foundation

struct Request {
    private let boundary: String = "Boundary-\(UUID().uuidString)"
    
    func createRequest(url: String, API: Requestable) throws -> URLRequest {
        guard let url = URL(string: url) else { throw NetworkError.invalidURL }
        
        var request = URLRequest(url: url)
        request.httpMethod = API.method.description
        
        if API.contentType == ContentType.multipart {
            request.setValue(API.contentType.description + boundary, forHTTPHeaderField: ContentType.httpHeaderField)
        } else {
            request.setValue(API.contentType.description, forHTTPHeaderField: ContentType.httpHeaderField)
        }
        
        if let api = API as? DeleteAPI {
            guard let body = try? JSONEncoder().encode(api.password) else {
                throw ParsingError.encodingFailed
            }
            request.httpBody = body
        } else if let api = API as? RequestableWithMultipartForm {
            let body = createBody(params: api.parameter, image: api.image)
            request.httpBody = body
            debugPrint(String(decoding: body, as: UTF8.self))
        }
        return request
    }
    
    private func createBody(params: [String: Any]?, image: [Media]?) -> Data {
        var body = Data()
        
        let lineBreak = "\r\n"
        
        if let parameters = params {
            for (key, value) in parameters {
                body.append("--\(boundary)\(lineBreak)")
                body.append("Content-Disposition: form-data; name=\"\(key)\"\(lineBreak + lineBreak)")
                body.append("\(value)\(lineBreak)")
            }
        }
        
        if let image = image {
            for photo in image {
                body.append("--\(boundary)\(lineBreak)")
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
