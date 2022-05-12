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

enum API<T: Codable> {
    case serverState
    case requestList(page: Int, itemsPerPage: Int)
    case requestProduct(id: Int)
    
    private static var host: String {
        "https://market-training.yagom-academy.kr/"
    }
    
    private static var session: URLSession {
        let configuration = URLSessionConfiguration.default
        configuration.waitsForConnectivity = true
        configuration.timeoutIntervalForResource = 300
        return URLSession(configuration: configuration)
    }
    
    private var urlString: String {
        switch self {
        case .serverState:
            return Self.host + "healthChecker"
        case .requestList(let page, let itemsPerPage):
            return Self.host + "api/products?items_per_page=\(itemsPerPage)&page_no=\(page)"
        case .requestProduct(let id):
            return Self.host + "api/products/\(id)"
        }
    }
}

//MARK: - Network Method

extension API {
    func checkServerState(session: URLSessionProtocol = session, completion: @escaping (Result<String, NetworkErorr>) -> Void) {
        guard let url = URL(string: urlString) else {
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
    
    func request(session: URLSessionProtocol = session, completion: @escaping (Result<T, NetworkErorr>) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(.failure(.urlError))
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
                jsonDecoder.dateDecodingStrategy = .formatted(.dateFormatter)
                
                let result = try jsonDecoder.decode(T.self, from: data)
                completion(.success(result))
            } catch {
                completion(.failure(.jsonError))
                return
            }
        }.resume()
    }
}

//MARK: - DateFormatter Method

private extension DateFormatter {
    static let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'hh:mm:ss.SS"
        return dateFormatter
    }()
}
