//
//  NetworkManager.swift
//  OpenMarket
//
//  Created by dudu, safari on 2022/05/10.
//

import Foundation

enum NetworkErorr: Error {
    case dataError
    case jsonError
    case severError
    case urlError
    case imageError
}

struct NetworkManager {
    private let session: URLSession
    
    init(session: URLSession = .customSession) {
        self.session = session
    }
    
    func checkServerState(completion: @escaping (Result<String, NetworkErorr>) -> Void) {
        guard let urlRequst = EndPoint.serverState.urlRequest else {
            completion(.failure(.urlError))
            return
        }
        
        session.dataTask(with: urlRequst) { data, response, error in
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode,
                    (200..<300).contains(statusCode),
                    error == nil else {
                completion(.failure(.severError))
                return
            }
            
            guard let data = data, let text = String(data: data, encoding: .utf8) else {
                completion(.failure(.dataError))
                return
            }
            
            completion(.success(text.trimmingCharacters(in:CharacterSet(charactersIn: "\""))))
        }.resume()
    }
    
    func request<T: Decodable>(endPoint: EndPoint, completion: @escaping (Result<T, NetworkErorr>) -> Void) {
        guard let urlRequst = endPoint.urlRequest else {
            completion(.failure(.urlError))
            return
        }
        
        session.dataTask(with: urlRequst) { data, response, error in
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode,
                    (200..<300).contains(statusCode),
                    error == nil else {
                completion(.failure(.severError))
                return
            }
            
            guard let data = data else {
                completion(.failure(.dataError))
                return
            }
            
            do {
                let result = try JSONDecoder().decode(T.self, from: data)
                completion(.success(result))
            } catch {
                completion(.failure(.jsonError))
                return
            }
        }.resume()
    }
}
