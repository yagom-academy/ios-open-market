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
    case serverState
    case requestList
    case requestProduct
    
    private static var host: String {
        "https://market-training.yagom-academy.kr/"
    }
    
    private static var session: URLSession {
        let config = URLSessionConfiguration.default
        config.waitsForConnectivity = true
        config.timeoutIntervalForResource = 300
        return URLSession(configuration: config)
    }
    
    private var path: String {
        switch self {
        case .serverState:
            return "healthChecker"
        case .requestList:
            return "api/products"
        case.requestProduct:
            return "api/products/"
        }
    }
    
    private var parameters: [String: String] {
        switch self {
        case .serverState:
            return [:]
        case .requestList:
            return ["page_no": "1","items_per_page": "10"]
        case .requestProduct:
            return [:]
        }
    }
}

//MARK: - Network Method

extension API {
    func checkServerState(session: URLSessionProtocol = session, completion: @escaping (Result<String, NetworkErorr>) -> Void) {
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
    
    func getData<T: Decodable>(session: URLSessionProtocol = session, id: String = "", completion: @escaping (Result<T, NetworkErorr>) -> Void) {
        var urlComponents = URLComponents(string: API.host + path + id)
        urlComponents?.configureQuery(parameters)
        
        guard let url = urlComponents?.url else {
            completion(.failure(.unknown))
            return
        }
        
        session.dataTask(with: url) { data, response, error in
            guard error == nil else {
                completion(.failure(.severError))
                return
            }
            
            guard let responseCode = (response as? HTTPURLResponse)?.statusCode, (200..<300).contains(responseCode) else {
                completion(.failure(.severError))
                return
            }
            
            guard let data = data else {
                completion(.failure(.unknown))
                return
            }
            
            let jsonDecoder = JSONDecoder()
            do {
                let productData = try jsonDecoder.decode(T.self, from: data)
                completion(.success(productData))
            } catch {
                completion(.failure(.jsonError))
                return
            }
        }.resume()
    }
}

//MARK: - ConfigureQuery Method

private extension URLComponents {
    mutating func configureQuery(_ paramters: [String: String]) {
        self.queryItems = paramters.map{ (key, value) in
            URLQueryItem(name: key, value: value)
        }
    }
}
