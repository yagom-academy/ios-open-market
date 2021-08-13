//
//  NetworkManager.swift
//  OpenMarket
//
//  Created by KimJaeYoun on 2021/08/13.
//

import Foundation

enum NetworkError: Error {
    case urlInvalid
    case requestError
    case responseError
}

struct NetworkManager {
    let session: URLSession
    typealias userInput = [String: Any]
    
    private func generateBoundary() -> String {
        return "--Boundary\(UUID().uuidString)"
    }
    
    private func makeContentDispositionLine() -> String {
        return "Content-Disposition: form-data; "
    }
    
    private func createHTTPBody(with parameters: userInput?, media: [Media]?) -> Data? {
        let boundary = generateBoundary()
        let lineBreak = "\r\n"
        var body = Data()
        
        if let parameters = parameters {
            for (key, value) in parameters {
                body.append(boundary + lineBreak)
                body.append("\(makeContentDispositionLine())name=\"\(key)\"\(lineBreak)")
                body.append("\(value) + \(lineBreak)")
            }
        }
        
        if let media = media {
            for image in media {
                body.append(boundary + lineBreak)
                body.append("\(makeContentDispositionLine())name=\"\(image.key)\"; filename=\"\(image.fileName)\"\(lineBreak)")
                body.append("Content-Type: \(image.mimeType)")
                body.append(image.data)
                body.append(lineBreak)
            }
        }
        
        body.append("--\(boundary)--\(lineBreak)")
        
        return body
    }

    private func createRequest(httpMethod: HTTPMethod, url: URL, body: Data?) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = String(describing: httpMethod)
        request.httpBody = body
        
        return request
    }
    
    func request(httpMethod: HTTPMethod, url: URL, body: Data?, completionHandler: @escaping (Result<Data, NetworkError>) -> ()) {
        let request = createRequest(httpMethod: httpMethod, url: url, body: body)
        
        session.dataTask(with: request) { (data, response, error) in
            guard error == nil else {
                completionHandler(.failure(.requestError))
                return
            }
            
            guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                completionHandler(.failure(.responseError))
                return
            }
            
            if let data = data {
                completionHandler(.success(data))
            }
        }.resume()
    }
}
