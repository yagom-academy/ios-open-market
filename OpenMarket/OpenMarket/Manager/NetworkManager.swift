//
//  NetworkManager.swift
//  OpenMarket
//
//  Created by JINHONG AN on 2021/08/13.
//

import Foundation

struct NetworkManager {
    private var dataTaskRequestable: DataTaskRequestable
    private let doubleHypen = "--"
    private let lineBreak = "\r\n"
    private var generateBoundary: String {
        return UUID().uuidString
    }
    
    init(dataTaskRequestable: DataTaskRequestable = NetworkModule()) {
        self.dataTaskRequestable = dataTaskRequestable
    }
    
    mutating func lookUpProductList(on pageNum: Int, completionHandler: @escaping (Result<Data, Error>) -> Void) {
        let methodForm = OpenMarketAPIConstants.listGet
        guard var url = methodForm.url else {
            return completionHandler(.failure(NetworkError.invalidURL))
        }
        url.appendPathComponent("\(pageNum)")
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = methodForm.method
        
        dataTaskRequestable.runDataTask(with: urlRequest, completionHandler: completionHandler)
    }
    
    mutating func registerProduct(with parameters: [String: Any], and medias: [Media], completionHandler: @escaping (Result<Data, Error>) -> Void) {
        let methodForm = OpenMarketAPIConstants.post
        let boundary = generateBoundary
        guard let url = methodForm.url else {
            return completionHandler(.failure(NetworkError.invalidURL))
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = methodForm.method
        urlRequest.setValue(createHeaderValue(mimeType: .multipartedFormData, separator: boundary), forHTTPHeaderField: OpenMarketAPIConstants.keyOfContentType)
        
        let dataBody = createDataBody(from: parameters, with: medias, separatedInto: boundary)
        urlRequest.httpBody = dataBody
        
        dataTaskRequestable.runDataTask(with: urlRequest, completionHandler: completionHandler)
    }
    
    private func createDataBody(from parameters: [String: Any], with medias: [Media]?, separatedInto boundary: String) -> Data {
        var body = Data()
        
        for (key, value) in parameters {
            body = body.appending("\(doubleHypen + boundary + lineBreak)")
            body = body.appending(createContentDisposition(with: key))
            body = body.appending("\(value)\(lineBreak)")
        }
        
        if let medias = medias {
            for media in medias {
                body = body.appending("\(doubleHypen + boundary + lineBreak)")
                body = body.appending(createContentDisposition(with: media.key, for: media))
                body = body.appending(createBodyContentType(about: media.contentType) + lineBreak + lineBreak)
                body.append(media.data)
                body = body.appending(lineBreak)
            }
        }
        
        body = body.appending("\(doubleHypen + boundary + doubleHypen + lineBreak)")
        return body
    }
    
    private func createContentDisposition(with key: String, for media: Media? = nil) -> String {
        var basicForm = "Content-Disposition: form-data; name=\"\(key)\""
        
        if let media = media {
            if let fileName = media.fileName {
                basicForm.append("; filename=\"\(fileName)\"")
            }
            basicForm.append("\(lineBreak)")
        } else {
            basicForm.append("\(lineBreak + lineBreak)")
        }
        
        return basicForm
    }
    
    private func createHeaderValue(mimeType: MimeType, separator boundary: String) -> String {
        return "\(mimeType); boundary=\(boundary)"
    }
    
    private func createBodyContentType(about mimeType: MimeType) -> String {
        return "\(OpenMarketAPIConstants.keyOfContentType): \(mimeType)"
    }
}

//TODO: -> PR 하고 -> 나머지 PATCH 등 구현 -> Mock Test

