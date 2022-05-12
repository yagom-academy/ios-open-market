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

enum EndPoint {
    case serverState
    case requestList(page: Int, itemsPerPage: Int)
    case requestProduct(id: Int)
}

extension EndPoint {
    private static var host: String {
        "https://market-training.yagom-academy.kr/"
    }
    
    var url: URL? {
        switch self {
        case .serverState:
            return URL(string: Self.host + "healthChecker")
        case .requestList(let page, let itemsPerPage):
            return URL(string: Self.host + "api/products?items_per_page=\(itemsPerPage)&page_no=\(page)")
        case .requestProduct(let id):
            return URL(string: Self.host + "api/products/\(id)")
        }
    }
}

struct NetworkManager<T: Codable> {
    private let session: URLSessionProtocol
    
    init(session: URLSessionProtocol = URLSession.customSession) {
        self.session = session
    }
    
    func checkServerState(completion: @escaping (Result<String, NetworkErorr>) -> Void) {
        guard let url = EndPoint.serverState.url else {
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
    
    func request(endPoint: EndPoint, completion: @escaping (Result<T, NetworkErorr>) -> Void) {
        guard let url = endPoint.url else {
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

//MARK: - Extension DateFormatter

private extension DateFormatter {
    static let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'hh:mm:ss.SS"
        return dateFormatter
    }()
}

//MARK: - Extension URLSession

private extension URLSession {
    static var customSession: URLSession {
        let configuration = URLSessionConfiguration.default
        configuration.waitsForConnectivity = true
        configuration.timeoutIntervalForResource = 300
        return URLSession(configuration: configuration)
    }
}
