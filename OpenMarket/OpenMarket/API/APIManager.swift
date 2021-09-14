//
//  APIManager.swift
//  OpenMarket
//
//  Created by 이예원 on 2021/09/04.
//

import UIKit

enum URI {    
    static let baseUrl = "https://camp-open-market-2.herokuapp.com/"
    static let fetchListPath = "\(baseUrl)items/"
    static let registerPath = "\(baseUrl)item/"
}

class APIManager {
    static let shared = APIManager()
    let session: URLSessionProtocol
    
    init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }
    
    let boundary = "Boundary-\(UUID().uuidString)"
    
    func networking(request: URLRequest, completion: @escaping (Result<Data, APIError>) -> Void) {
        let task = session.dataTask(with: request) { data, response, error in
            guard error == nil else {
                completion(.failure(.requestFailed))
                return
            }
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(.unknown))
                return
            }
            if let data = data {
                completion(.success(data))
            }
        }
        task.resume()
    }
    
    func createHTTPBody(parameters: [String: Any]?, media: [Media]?) -> Data {
        let lineBreak = "\r\n"
        let lastBoundary = "--\(boundary)--\(lineBreak)"
        let contentDisposition = "Content-Disposition: form-data; name="
        let contentType = "Content-Type: "
        
        var body = Data()
        
        if let parameters = parameters {
            for (key, value) in parameters {
                body.append("--\(boundary)\(lineBreak)")
                body.append("\(contentDisposition)\"\(key)\"\(lineBreak)\(lineBreak)")
                body.append("\(value)\(lineBreak)")
            }
        }
        
        if let media = media {
            for image in media {
                body.append("--\(boundary)\(lineBreak)")
                body.append("\(contentDisposition)\"\(image.key)\"; filename=\"\(image.fileName)\"\(lineBreak)")
                body.append("\(contentType) \(image.mimeType)\(lineBreak)\(lineBreak)")
                body.append(image.imageData)
                body.append(lineBreak)
            }
        }
        body.append(lastBoundary)
        return body
    }
    
    func fetchProductList(page: Int, completion: @escaping (Result<Data, APIError>) -> Void) {
        guard let url = URL(string: "\(URI.fetchListPath)\(page)") else {
            return completion(.failure(.invalidURL))
        }
        let urlRequest = URLRequest(url: url)
        networking(request: urlRequest, completion: completion)
    }
    
    func registProduct(parameters: [String: Any], media: [Media], completion: @escaping (Result<Data, APIError>) -> Void) {
        guard let url = URL(string: URI.registerPath) else {
            return completion(.failure(.invalidURL))
        }
        var urlRequest = URLRequest(url: url)
        
        let httpHeader = "multipart/form-data; boundary=\(boundary)"
        let httpHeaderField = "Content-Type"
        
        urlRequest.httpMethod = "post"
        urlRequest.setValue(httpHeader, forHTTPHeaderField: httpHeaderField)
        urlRequest.httpBody = createHTTPBody(parameters: parameters, media: media)
        
        networking(request: urlRequest, completion: completion)
    }
}
