//
//  HTTPBodyMaker.swift
//  OpenMarket
//
//  Created by KimJaeYoun on 2021/08/24.
//

import Foundation

struct HTTPBodyMaker {
    //MARK: HTTPBody Parameter Type
    typealias requestBodyType = [String: Any]
    
    //MARK: Private Method
    private func makeContentDispositionLine(contentType: ContentType) -> String {
        return "Content-Disposition: \(contentType); "
    }
    
    //MARK: Method
    func createHTTPBody(contentType: ContentType, with parameters: requestBodyType?, media: [Media]?) -> Data? {
        let lineBreak = "\r\n"
        var body = Data()
        
        if let parameters = parameters {
            for (key, value) in parameters {
                body.append(Boundary.literal + lineBreak)
                
                switch contentType {
                case .json:
                    body.append("\(makeContentDispositionLine(contentType: .json))\(lineBreak)")
                    guard let jsonData = value as? Data else {
                        return nil
                    }
                    body.append(jsonData)
                case .multipart:
                    body.append("\(makeContentDispositionLine(contentType: .multipart))name=\"\(key)\"\(lineBreak)")
                    body.append("\(value)\(lineBreak)")
                }
            }
        }
        
        if let media = media {
            for image in media {
                body.append(Boundary.literal + lineBreak)
                body.append("\(makeContentDispositionLine(contentType: .multipart))name=\"\(image.key)\"; filename=\"\(image.fileName)\"\(lineBreak)")
                body.append("Content-Type: \(image.mimeType)")
                body.append(image.data)
                body.append(lineBreak)
            }
        }
        
        body.append("--\(Boundary.literal)--\(lineBreak)")
        
        return body
    }
}
