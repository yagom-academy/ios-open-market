//
//  APIProtocol.swift
//  OpenMarket
//
//  Created by 전민수 on 2022/07/26.
//

import Foundation

protocol APIProtocol {
    var configuration: APIConfiguration { get }
}

extension APIProtocol {
    func retrieveProduct<T: Decodable>(using client: APIClient = APIClient.shared,
                                    dataType: T.Type,
                                    completion: @escaping (Result<T,APIError>) -> Void) {
        
        var request = URLRequest(url: configuration.url)
        request.httpMethod = configuration.method.rawValue
        
        client.requestData(with: request) { result in
            switch result {
            case .success(let data):
                do {
                    let decodedData = try JSONDecoder().decode(T.self,
                                                               from: data)
                    completion(.success(decodedData))
                } catch {
                    completion(.failure(.failedToDecode))
                }
                
                return
            case .failure(_):
                completion(.failure(.emptyData))
                
                return
            }
        }
    }
    
    func enrollData(using client: APIClient = APIClient.shared,
                    postEntity: EnrollProductEntity,
                    completion: @escaping (Result<Data,APIError>) -> Void) {
        
        var request = URLRequest(url: configuration.url)
        
        let dataBody = createDataBody(withParameters: postEntity.parameter,
                                      media: postEntity.images,
                                      boundary: MIMEType.generateBoundary())
        
        request.httpMethod = configuration.method.rawValue
        request.httpBody = dataBody
        request.setValue(MIMEType.multipartFormData.value,
                         forHTTPHeaderField: MIMEType.contentType.value)
        request.addValue(User.identifier.rawValue,
                         forHTTPHeaderField: RequestName.identifier.key)
        
        client.requestData(with: request) { result in
            switch result {
            case .success(_):
                return
            case .failure(_):
                return
            }
        }
    }
    
    func modifyData(using client: APIClient = APIClient.shared,
                    modifiedProductEntity: ModifiedProductEntity,
                    completion: @escaping (Result<Data,APIError>) -> Void) {
        
        var request = URLRequest(url: configuration.url)
        
        request.httpBody = modifiedProductEntity.returnValue()
        request.httpMethod = configuration.method.rawValue
        request.setValue(MIMEType.applicationJSON.value,
                                   forHTTPHeaderField: MIMEType.contentType.value)
        request.addValue(User.identifier.rawValue,
                                   forHTTPHeaderField: RequestName.identifier.key)
        
        print("jsonData: ", String(data: request.httpBody!, encoding: .utf8) ?? "no body data")

        client.requestData(with: request) { result in
            switch result {
            case .success(let data):
                return
            case .failure(_):
                return
            }
        }
    }
    
    func retrieveSecret(using client: APIClient = APIClient.shared,
                        completion: @escaping (Result<Data,APIError>) -> Void) {
        
        var request = URLRequest(url: configuration.url)
        
        do {
            let param = ["secret" : User.secret.rawValue]
            let dataBody = try JSONSerialization.data(withJSONObject: param, options: .init())
            
            request.httpBody = dataBody
            request.httpMethod = configuration.method.rawValue
            request.setValue(MIMEType.applicationJSON.value, forHTTPHeaderField: MIMEType.contentType.value)
            request.addValue(User.identifier.rawValue, forHTTPHeaderField: RequestName.identifier.key)
            
            client.requestData(with: request) { result in
                switch result {
                case .success(let data):
                    return
                case .failure(_):
                    return
                }
            }
        } catch {
            completion(.failure(.invalidURL))
        }
    }
    
    func deleteProduct(using client: APIClient = APIClient.shared,
                       completion: @escaping (Result<Data,APIError>) -> Void) {
        var deleteRequest = URLRequest(url: configuration.url)
        deleteRequest.httpMethod = configuration.method.rawValue
        deleteRequest.setValue(MIMEType.applicationJSON.value, forHTTPHeaderField: MIMEType.contentType.value)
        deleteRequest.addValue(User.identifier.rawValue, forHTTPHeaderField: RequestName.identifier.key)
        
        client.requestData(with: deleteRequest) { result in
            switch result {
            case .success(let data):
                return
            case .failure(_):
                return
            }
        }
    }
}

//MARK: - Product Enrollment

extension APIProtocol {
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
