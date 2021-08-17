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
    typealias userInput = [String: Any]

    let session: URLSession
    private let boundary = "Boundary\(UUID().uuidString)"
    
    private func makeContentDispositionLine(contentType: ContentType) -> String {
        return "Content-Disposition: \(contentType); "
    }
    
    private func createHTTPBody(contentType: ContentType, with parameters: userInput?, media: [Media]?) -> Data? {
        let lineBreak = "\r\n"
        var body = Data()
        
        switch contentType {
        case .multipart:
            if let parameters = parameters {
                for (key, value) in parameters {
                    body.append(boundary + lineBreak)
                    body.append("\(makeContentDispositionLine(contentType: .multipart))name=\"\(key)\"\(lineBreak)")
                    body.append("\(value) + \(lineBreak)")
                }
            }
        case .json:
            if let parameters = parameters {
                for (_, value) in parameters {
                    body.append(boundary + lineBreak)
                    body.append("\(makeContentDispositionLine(contentType: .json))\(lineBreak)")
                    body.append("\(value) + \(lineBreak)")
                }
            }
        }

        if let media = media {
            for image in media {
                body.append(boundary + lineBreak)
                body.append("\(makeContentDispositionLine(contentType: .multipart))name=\"\(image.key)\"; filename=\"\(image.fileName)\"\(lineBreak)")
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
    
    func request(httpMethod: HTTPMethod, url: URL, body: Data?, _ contentType: ContentType, _ completionHandler: @escaping (Result<Data, NetworkError>) -> ()) {
        var request = createRequest(httpMethod: httpMethod, url: url, body: body)
        request.setValue("\(contentType); boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
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
