//
//  URLSessionProvider.swift
//  OpenMarket
//
//  Created by marlang, Taeangel on 2022/05/12.
//

import UIKit

struct URLSessionProvider<T: Decodable> {
    private let session: URLSessionProtocol
    
    init (session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }
    
    func fetchData(
        from url: Endpoint,
        completionHandler: @escaping (Result<T, NetworkError>) -> Void) {
            guard let url = url.url else {
                completionHandler(.failure(.urlError))
                return
            }
            
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = "GET"
            
            request(with: urlRequest, completionHandler: completionHandler)
        }
    
    private func request(
        with request: URLRequest,
        completionHandler: @escaping (Result<T, NetworkError>) -> Void
    ) {
        let task = session.dataTask(with: request) { data, urlResponse, error in
            
            guard error == nil else {
                completionHandler(.failure(.clientError))
                return
            }
            
            guard let httpResponse = urlResponse as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                completionHandler(.failure(.statusCodeError))
                return
            }
            
            guard let data = data else {
                completionHandler(.failure(.dataError))
                return
            }
            
            guard let resultData = T.parse(data: data) else {
                completionHandler(.failure(.decodeError))
                return
            }
            
            completionHandler(.success(resultData))
        }
        task.resume()
    }
    
    func createBody(params: ProductRegistration, images: [Image], boundary: String) -> Data? {
        var body = Data()
        let newline = "\r\n"
        let boundaryPrefix = "--\(boundary)\r\n"
        let boundarySuffix = "\r\n--\(boundary)--\r\n"
        
        guard let product = try? Json.encoder.encode(params) else {
            return nil
        }
        
        body.appendString(boundaryPrefix)
        body.appendString("Content-Disposition: form-data; name=\"params\"")
        body.appendString(newline)
        body.appendString(newline)
        body.append(product)
        body.appendString(newline)

        for image in images {
            body.appendString(boundaryPrefix)
            body.appendString("Content-Disposition: form-data; name=\"images\"; filename=\"\(image.fileName).jpeg\"")
            body.appendString(newline)
            body.appendString("Content-Type: image/\(image.type)")
            body.appendString(newline)
            body.appendString(newline)
            body.append(image.data)
            body.appendString(newline)
        }

        body.appendString(boundarySuffix)
        return body
    }
}
