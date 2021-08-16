//
//  NetworkManager.swift
//  OpenMarket
//
//  Created by 오승기 on 2021/08/13.
//

import Foundation

enum RequestType: String {
    case get = "GET"
    case post = "POST"
    case delete = "DELETE"
    case patch = "PATCH"
    
    var method: String {
        return self.rawValue
    }
}

enum NetworkError: Error {
    case invalidHandler
    case invalidURL
    case failResponse
    case invalidData
    case unownedError
}

protocol Networkable {
    func dataTask(with request: URLRequest, completionHandler: @escaping(Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}

extension URLSession: Networkable {}

typealias URLSessionResult = ((Result<Data, NetworkError>) -> Void)

class NetworkManager {
    private let session: Networkable
    
    init(session: Networkable = URLSession.shared) {
        self.session = session
    }
    
    func request(requsetType: RequestType, url: String, model: Data?, completion: @escaping URLSessionResult) {
        
        guard let url = URL(string: url) else {
            return completion(.failure(NetworkError.invalidURL))
        }
        
        var request = URLRequest(url: url)
        
        switch requsetType {
        case .get:
            request.httpMethod = requsetType.method
        case .patch, .post:
            request.httpMethod = requsetType.method
            guard let model = model else { return }
            request.httpBody = model
        case .delete:
            request.httpMethod = requsetType.method
            guard let model = model else { return }
            request.httpBody = model
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        session.dataTask(with: request) { data, response, error in
            guard error == nil else {
                completion(.failure(NetworkError.unownedError))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completion(.failure(NetworkError.failResponse))
                return
            }
            
            guard let data = data else {
                completion(.failure(NetworkError.invalidData))
                return
            }
            completion(.success(data))
        } .resume()
    }
}


