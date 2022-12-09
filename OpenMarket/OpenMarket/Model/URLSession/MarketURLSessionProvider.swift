//
//  MarketURLSessionProvider.swift
//  OpenMarket
//
//  Created by 써니쿠키, 메네 on 2022/11/15.
//

import UIKit

final class MarketURLSessionProvider {
    private let session: URLSessionProtocol
    private var market: Market?
    
    init(session: URLSessionProtocol = URLSession(configuration: .default)) {
        self.session = session
    }
    
    func fetchData(request: URLRequest,
                   completionHandler: @escaping (Result<Data, NetworkError>) -> Void) {
        let dataTask = session.dataTask(with: request) { data, response, error in
            guard error == nil else {
                return completionHandler(.failure(.requestFailError))
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                return completionHandler(.failure(.httpResponseError(
                    code: (response as? HTTPURLResponse)?.statusCode ?? 0)))
            }
            
            guard let data = data else {
                return completionHandler(.failure(.noDataError))
            }
            
            completionHandler(.success(data))
        }
        
        dataTask.resume()
    }
    
    func uploadData(request: URLRequest,
                    completionHandler: @escaping (Result<Data, NetworkError>) -> Void) {
        let dataTask = session.dataTask(with: request) { data, response, error in
            guard error == nil else {
                return completionHandler(.failure(.requestFailError))
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                return completionHandler(.failure(.httpResponseError(
                    code: (response as? HTTPURLResponse)?.statusCode ?? 0)))
            }
            
            guard let data = data else {
                return completionHandler(.failure(.noDataError))
            }
            
            return completionHandler(.success(data))
        }
        
        dataTask.resume()
    }
}

extension MarketURLSessionProvider {
    func generateRequest(textParameters: [String : Data],
                         imageKey: String, images: [UIImage]) -> URLRequest? {
        let lineBreak = "\r\n"
        let boundary = "Boundary-\(UUID().uuidString)"
        
        guard let url = Request.productRegistration.url else {
            print(NetworkError.generateUrlFailError.localizedDescription)
            return nil
        }
        
        var request = URLRequest(url: url)
        
        request.httpMethod = HttpMethod.post.name
        request.addValue("multipart/form-data; boundary=\(boundary)",
                         forHTTPHeaderField: "Content-Type")
        request.addValue("b7069a7d-6940-11ed-a917-1f26f7cfa9c9",
                         forHTTPHeaderField: "identifier")
        
        let stringBodyData = createTextBodyData(parameters: textParameters,
                                                boundary: boundary)
        
        guard let imageBodyData = createImageBodyData(key: imageKey,
                                                      images: images,
                                                      boundary: boundary) else {
            print(NetworkError.generateImageDataFailError.localizedDescription)
            return nil
        }
        
        var bodyData = Data()
        
        bodyData.append(stringBodyData)
        bodyData.append(imageBodyData)
        bodyData.append("--\(boundary)--\(lineBreak)")
        
        request.httpBody = bodyData
        
        return request
    }
    
    private func createTextBodyData(parameters: [String : Data],
                                    boundary: String) -> Data {
        let lineBreak = "\r\n"
        var body = Data()
        
        for (key, value) in parameters {
            body.append("--\(boundary + lineBreak)")
            body.append("Content-Disposition: form-data; name=\"\(key)\"\(lineBreak + lineBreak)")
            body.append(value)
            body.append(lineBreak)
        }
        
        return body
    }
    
    private func createImageBodyData(key: String,
                                     images: [UIImage],
                                     boundary: String) -> Data? {
        let lineBreak = "\r\n"
        var body = Data()
        
        for image in images {
            guard let imageData = image.jpegData(compressionQuality: 0.5) else {
                print(NetworkError.generateImageDataFailError.localizedDescription)
                return nil
            }
            
            body.append("--\(boundary + lineBreak)")
            body.append("Content-Disposition: form-data; name=\"\(key)\"; filename=\"image\"")
            body.append(lineBreak)
            body.append("Content-Type: \"multipart/form-data\"")
            body.append(lineBreak + lineBreak)
            body.append(imageData)
            body.append(lineBreak)
        }
        
        return body
    }
}

extension MarketURLSessionProvider {
    private enum HttpMethod {
        case get
        case post
        case patch
        case delete
        
        var name: String {
            switch self {
            case .get:
                return "GET"
            case .post:
                return "POST"
            case .patch:
                return "PATCH"
            case .delete:
                return "DEL"
            }
        }
    }
}

extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            self.append(data)
        }
    }
}
