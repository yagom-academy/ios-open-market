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
    
    func uploadProduct(textParameters: [String : String],
                       imageKey: String,
                       images: [(imageName: String, image: UIImage)]) {
        guard let request = generateRequest(textParameters: textParameters,
                                            imageKey: imageKey,
                                            images: images) else { return }
        
        guard let session = session as? URLSession else { return }
        
        let dataTask = session.dataTask(with: request) { data, response, error in
            guard error == nil else {
                print(NetworkError.requestFailError)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                return  print(NetworkError.httpResponseError(
                    code: (response as? HTTPURLResponse)?.statusCode ?? 0))
            }
            
            guard data != nil else {
                print(NetworkError.noDataError)
                return
            }
        }
        
        dataTask.resume()
    }
}

extension MarketURLSessionProvider {
    func generateRequest(textParameters: [String : String], imageKey: String, images: [(imageName: String, image: UIImage)]) -> URLRequest? {
        let lineBreak = "\r\n"
        let boundary = "Boundary-\(UUID().uuidString)"
        
        guard let url = Request.productRegistration.url else { return nil }
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        
        request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.addValue("b7069a7d-6940-11ed-a917-1f26f7cfa9c9", forHTTPHeaderField: "identifier")
        
        let stringBodyData = createTextBodyData(parameters: textParameters, boundary: boundary)
        let imageBodyData = createImageBodyData(key: imageKey, images: images, boundary: boundary)
        var bodyData = Data()
        
        bodyData.append(stringBodyData)
        bodyData.append(imageBodyData)
        bodyData.append("--\(boundary)--\(lineBreak)")
        
        request.httpBody = bodyData
        
        return request
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
