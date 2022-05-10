//
//  Network.swift
//  OpenMarket
//
//  Created by dudu, safari on 2022/05/10.
//

import Foundation

enum NetworkErorr: Error {
    case unknown
    case jsonError
    case severError
    case urlError
}

enum API {
    static let host = "https://market-training.yagom-academy.kr/"
    static func request(session: URLSessionProtocol, path: String = "", paramters: [String: String] = [:]) -> Network {
        Network(session: session, path: path, paramters: paramters)
    }
}

struct Network {
    private let session: URLSessionProtocol
    private let path: String
    private let parameters: [String: String]
    
    init(session: URLSessionProtocol, path: String, paramters: [String: String]) {
        self.session = session
        self.path = path
        self.parameters = paramters
    }
    
    func checkServerState(completion: @escaping (Result<String, NetworkErorr>) -> Void) {
        var urlComponents = URLComponents(string: API.host + path)
        urlComponents?.configureQuery(parameters)
        
        guard let url = urlComponents?.url else {
            completion(.failure(.urlError))
            return
        }
        
        session.dataTask(with: url) { data, response, error in
            guard error == nil else {
                completion(.failure(.severError))
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, (200..<300).contains(statusCode) else {
                completion(.failure(.severError))
                return
            }
            
            guard let data = data, let text = String(data: data, encoding: .utf8) else {
                completion(.failure(.unknown))
                return
            }
            
            completion(.success(text))
        }.resume()
    }
}

extension URLComponents {
    mutating func configureQuery(_ paramters: [String: String]) {
        self.queryItems = paramters.map{ (key, value) in
            URLQueryItem(name: key, value: value)
        }
    }
}
