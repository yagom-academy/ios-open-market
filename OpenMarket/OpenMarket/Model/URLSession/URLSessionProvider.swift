//
//  URLSessionProvider.swift
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
    
    func fetchData(url: URL, completionHandler: @escaping (Result<Data, NetworkError>) -> Void) {
        let dataTask = session.dataTask(with: url) { data, response, error in
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
    
    func uploadData() {
        
    }
    
    func createTextBodyData(parameters: [String : String], boundary: String) -> Data {
        let lineBreak = "\r\n"
        var body = Data()
        for (key, value) in parameters {
            body.append("--\(boundary + lineBreak)")
            body.append("Content-Disposition: form-data; name=\"\(key)\"\(lineBreak + lineBreak)")
            body.append("\(value + lineBreak)")
        }
        
        return body
    }
    
    func createImageBodyData(key: String,
                             images: [(imageName: String, image: UIImage)],
                             boundary: String) -> Data {
        let lineBreak = "\r\n"
        var body = Data()
        
        for (imageName, image) in images {
            if let data = image.jpegData(compressionQuality: 0.5) {
                body.append("--\(boundary + lineBreak)")
                body.append("Content-Disposition: form-data; name=\"\(key)\"; filename=\"\(imageName)\"")
                body.append(lineBreak)
                body.append("Content-Type: \"multipart/form-data\"")
                body.append(lineBreak + lineBreak)
                body.append(data)
                body.append(lineBreak)
            }
        }
        
        return body
    }
}

extension Data {
    public mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            self.append(data)
        }
    }
}
