//
//  NetworkManager.swift
//  OpenMarket
//
//  Created by JINHONG AN on 2021/08/13.
//

import Foundation

struct NetworkManager {
    private var dataTaskRequestable: DataTaskRequestable
    
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
        
        dataTaskRequestable.runDataTask(using: urlRequest, with: completionHandler)
    }
    
    mutating func registerProduct(with parameters: [String: Any], and medias: [Media], completionHandler: @escaping (Result<Data, Error>) -> Void) {
        let methodForm = OpenMarketAPIConstants.post
        let boundary = generateBoundary()
        guard let url = methodForm.url else {
            return completionHandler(.failure(NetworkError.invalidURL))
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = methodForm.method
        urlRequest.setValue(createHeaderValue(mimeType: .multipartedFormData, separator: boundary), forHTTPHeaderField: OpenMarketAPIConstants.keyOfContentType)
        
        let dataBody = createDataBody(with: parameters, and: medias, separatedInto: boundary)
        urlRequest.httpBody = dataBody
        
        dataTaskRequestable.runDataTask(using: urlRequest, with: completionHandler)
    }
    
    private func generateBoundary() -> String {
        return UUID().uuidString
    }
    
    private func createDataBody(with parameters: [String: Any], and medias: [Media]?, separatedInto boundary: String) -> Data {
        let linebreak = OpenMarketAPIConstants.lineBreak
        let doubleHypen = OpenMarketAPIConstants.doubleHypen
        var body = Data()
        
        for (key, value) in parameters {
            body.append("\(doubleHypen + boundary + linebreak)")
            body.append(createContentDisposition(with: key))
            body.append("\(value)\(linebreak)")
        }
        
        if let medias = medias {
            for media in medias {
                body.append("\(doubleHypen + boundary + linebreak)")
                body.append(createContentDisposition(with: media.key, for: media))
                body.append(createBodyContentType(about: media.contentType) + linebreak + linebreak)
                body.append(media.data)
                body.append(linebreak)
            }
        }
        
        body.append("\(doubleHypen + boundary + doubleHypen + linebreak)")
        return body
    }
    
    private func createContentDisposition(with key: String, for media: Media? = nil) -> String {
        let lineBreak = OpenMarketAPIConstants.lineBreak
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

