//
//  APIRequest.swift
//  OpenMarket
//
//  Created by groot, bard on 2022/07/12.
//

import Foundation

enum HTTPMethod {
    case get
    case post
    case delete
    case patch
    case put
    
    var name: String {
        switch self {
        case .get:
            return "GET"
        case .post:
            return "POST"
        case .delete:
            return "DELETE"
        case .patch:
            return "PATCH"
        case .put:
            return "PUT"
        }
    }
}

enum URLHost {
    case openMarket
    
    var url: String {
        switch self {
        case .openMarket:
            return "https://market-training.yagom-academy.kr"
        }
    }
}

enum URLAdditionalPath {
    case healthChecker
    case product
    
    var value: String {
        switch self {
        case .healthChecker:
            return "/healthChecker"
        case .product:
            return "/api/products"
        }
    }
}

protocol APIRequest {
    var method: HTTPMethod { get }
    var baseURL: String { get }
    var headers: [String: String]? { get }
    var query: [URLQueryItem]? { get }
    var body: Data? { get }
}

extension APIRequest {
    var url: URL? {
        var component = URLComponents(string: self.baseURL)
        component?.queryItems = query

        return component?.url
    }
    
    var urlRequest: URLRequest? {
        guard let url = self.url else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = self.method.name
        request.httpBody = self.body
        self.headers?.forEach { request.addValue($0, forHTTPHeaderField: $1) }
        
        return request
    }
    
    func execute<T: Codable>(completion: @escaping (Result<T, Error>) -> Void) {
        guard let request = self.urlRequest else { return }
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard error == nil else {
                completion(.failure(NetworkError.request))
                return
            }
            
            guard let response = response as? HTTPURLResponse,
                  200 <= response.statusCode, response.statusCode < 300
            else {
                completion(.failure(NetworkError.response))
                return
            }
            
            guard let safeData = data else {
                completion(.failure(NetworkError.invalidData))
                return
            }
            
            guard let decodedData = try? JSONDecoder().decode(T.self, from: safeData)
            else {
                completion(.failure(CodableError.decode))
                return
            }
            completion(.success(decodedData))
        }
        task.resume()
    }
}
