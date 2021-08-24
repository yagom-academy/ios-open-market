//
//  NetworkManager.swift
//  OpenMarket
//
//  Created by KimJaeYoun on 2021/08/13.
//

import Foundation

//MARK:-NetworkManager Error
enum NetworkError: Error {
    case urlInvalid
    case requestError
    case responseError
}

//MARK:-NetworkManager
struct NetworkManager {
 
    //MARK: Properties
    static var session: URLSession = URLSession.shared
    
    //MARK: Private Method
    private static func createRequest(httpMethod: HTTPMethod, url: URL, body: Data?, _ contentType: ContentType) -> URLRequest {
        var request = URLRequest(url: url)
        request.setValue("\(contentType); boundary=\(Boundary.literal)", forHTTPHeaderField: "Content-Type")
        request.httpMethod = String(describing: httpMethod)
        request.httpBody = body
        return request
    }
    
    //MARK: Method
        static func request(httpMethod: HTTPMethod, url: URL, body: Data?, _ contentType: ContentType, _ completionHandler: @escaping (Result<Data, NetworkError>) -> ()) {
        let request = createRequest(httpMethod: httpMethod, url: url, body: body, contentType)
        
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
