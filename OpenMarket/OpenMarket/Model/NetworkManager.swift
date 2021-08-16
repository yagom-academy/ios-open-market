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
    
    func requestGet(url: String, completion: @escaping URLSessionResult) {
        guard let url = URL(string: url) else {
            return completion(.failure(.invalidURL))
        }
        var request = URLRequest(url: url)
        request.httpMethod = RequestType.get.method
        session.dataTask(with: request) { data, response, error in
            guard error == nil else {
                return completion(.failure(.unownedError))
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                return completion(.failure(.failResponse))
            }
            
            guard let data = data else {
                return completion(.failure(.invalidData))
            }
            
            completion(.success(data))
        }.resume()
    }
}


