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
}

//MARK: - Network Method

extension API {
    func checkServerState(session: URLSessionProtocol = session, completion: @escaping (Result<String, NetworkErorr>) -> Void) {
        let urlComponents = URLComponents(string: API.host + path)
        
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
            
            
            completion(.success(text.trimmingCharacters(in:CharacterSet(charactersIn: "\""))))
        }.resume()
    }
    
    func getData(session: URLSessionProtocol = session, id: Int, completion: @escaping (Result<Product, NetworkErorr>) -> Void) {
        let urlComponents = URLComponents(string: API.host + path + "\(id)")
        
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
            
            do {
                let jsonDecoder = JSONDecoder()
                jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                
                let productData = try jsonDecoder.decode(Product.self, from: data)
                completion(.success(productData))
            } catch {
                completion(.failure(.jsonError))
                return
            }
        }.resume()
    }
    
    func getData(session: URLSessionProtocol = session, page: Int, itemsPerPage: Int, completion: @escaping (Result<ProductList, NetworkErorr>) -> Void) {
        var urlComponents = URLComponents(string: API.host + path)
        let parameters = ["page_no": "\(page)","items_per_page": "\(itemsPerPage)"]
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
            
            do {
                let jsonDecoder = JSONDecoder()
                jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                
                let productData = try jsonDecoder.decode(ProductList.self, from: data)
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
