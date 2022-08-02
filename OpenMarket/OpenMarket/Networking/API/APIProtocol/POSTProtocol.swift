//
//  POSTProtocol.swift
//  OpenMarket
//
//  Created by 전민수 on 2022/08/02.
//

import Foundation

protocol POSTProtocol: APIProtocol { }

extension POSTProtocol {
    func requestProductEnrollment(using client: APIClient = APIClient.shared,
                    postEntity: EnrollProductEntity,
                    completion: @escaping (Result<Data, APIError>) -> Void) {
        
        var request = URLRequest(url: configuration.url)
        
        let dataBody = createDataBody(withParameters: postEntity.parameter,
                                      media: postEntity.images,
                                      boundary: MIMEType.generateBoundary())
        
        request.httpMethod = HTTPMethod.post.rawValue
        request.httpBody = dataBody
        request.setValue(MIMEType.multipartFormData.value,
                         forHTTPHeaderField: MIMEType.contentType.value)
        request.addValue(User.identifier.rawValue,
                         forHTTPHeaderField: RequestName.identifier.key)
        
        client.requestData(with: request) { result in
            switch result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func requestAndDecodeProductSecret(using client: APIClient = APIClient.shared,
                        completion: @escaping (Result<Data,APIError>) -> Void) {
        
        var request = URLRequest(url: configuration.url)
        
        do {
            let param = ["secret" : User.secret.rawValue]
            let dataBody = try JSONSerialization.data(withJSONObject: param, options: .init())
            
            request.httpBody = dataBody
            request.httpMethod = HTTPMethod.post.rawValue
            request.setValue(MIMEType.applicationJSON.value, forHTTPHeaderField: MIMEType.contentType.value)
            request.addValue(User.identifier.rawValue, forHTTPHeaderField: RequestName.identifier.key)
            
            client.requestData(with: request) { result in
                switch result {
                case .success(_):
                    return
                case .failure(_):
                    return
                }
            }
        } catch {
            completion(.failure(.invalidURL))
        }
    }
    
    private func createDataBody(withParameters params: PostParameter,
                                media: [ProductImage]?,
                                boundary: String) -> Data {
        let lineBreak = "\r\n"
        var body = Data()
        
        body.append("--\(boundary + lineBreak)")
        body.append("Content-Disposition: form-data; name=\"\(RequestName.params.key)\"\(lineBreak + lineBreak)")
        body.append(params.returnValue()!)
        body.append(lineBreak)
        
        if let media = media {
            for photo in media {
                body.append("--\(boundary + lineBreak)")
                body.append("Content-Disposition: form-data; name=\"\(RequestName.images.key)\"; filename=\"\(photo.fileName)\"\(lineBreak)")
                body.append("Content-Type: \(photo.mimeType.value + lineBreak + lineBreak)")
                body.append(photo.data)
                body.append(lineBreak)
            }
        }
        
        body.append("--\(boundary)--\(lineBreak)")
        
        return body
    }
}

fileprivate extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}
