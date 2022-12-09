//
//  NetworkManager.swift
//  OpenMarket
//
//  Created by Ayaan, junho on 2022/11/30.
//

import UIKit.UIImage

struct NetworkManager {
    let openMarketAPI: OpenMarketAPI
    private var bodyData: Data? {
        switch openMarketAPI {
        case .checkHealth:
            return nil
        case .fetchPage:
            return nil
        case .fetchProduct:
            return nil
        case .registration(let product, let images, let boundary):
            var body: Data = .init()
                        
            if let productData: Data = try? JSONEncoder().encode(product) {
                body.append("--\(boundary)\r\n")
                body.append("Content-Disposition: form-data; name=\"params\"\r\n\r\n")
                body.append(productData)
                body.append("\r\n")
            }
            images.compactMap({ $0.jpegData(compressionQuality: 1.0) }).forEach {
                body.append("--\(boundary)\r\n")
                body.append("Content-Disposition: form-data; name=\"images\"; filename=\"\(UUID().uuidString)\"\r\n")
                body.append("Content-Type: image/jpeg\r\n\r\n")
                body.append($0)
                body.append("\r\n")
            }
            body.append("--\(boundary)--")
            
            return body
        case .update(let product):
            guard let productData: Data = try? JSONEncoder().encode(product) else {
                return nil
            }
            return productData
        case .inquiryDeregistrationURI:
            guard let secretData: Data = try? JSONEncoder().encode(Secret(secretKey: "xwxdkq8efjf3947z")) else {
                return nil
            }
            return secretData
        case .deregistration:
            return nil
        }
    }
    
    func network(completionHandler: @escaping (Data?, Error?) -> Void) {
        guard let hostURL: URL = .init(string: openMarketAPI.baseURL),
              let url: URL = .init(string: openMarketAPI.path, relativeTo: hostURL) else {
            completionHandler(nil, OpenMarketError.invalidURL())
            return
        }
        var request: URLRequest = .init(url: url)
        openMarketAPI.headers.forEach {
            request.addValue($0.value, forHTTPHeaderField: $0.key)
        }
        request.httpMethod = openMarketAPI.method.text
        request.httpBody = bodyData
        
        URLSession.shared.dataTask(with: request) {data, response, error in
            if let error: Error = error {
                completionHandler(nil, error)
            } else if let httpResponse: HTTPURLResponse = response as? HTTPURLResponse,
                      (200...299).contains(httpResponse.statusCode) == false {
                completionHandler(nil, OpenMarketError.badStatus())
            } else if let data: Data = data {
                completionHandler(data, nil)
            } else {
                completionHandler(nil, OpenMarketError.unknownError())
            }
        }.resume()
    }
}
