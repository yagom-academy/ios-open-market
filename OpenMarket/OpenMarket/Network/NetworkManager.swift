//
//  NetworkManager.swift
//  OpenMarket
//
//  Created by dudu, safari on 2022/05/10.
//

import Foundation

enum NetworkError: Error {
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
    
    func request(api: APIable, completion: @escaping (Result<String, NetworkError>) -> Void) {
        guard let urlRequst = api.makeURLRequest() else {
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
            
            completion(.success(text))
        }.resume()
    }
    
    func request<T: Decodable>(api: APIable, completion: @escaping (Result<T, NetworkError>) -> Void) {
        guard let urlRequest = api.makeURLRequest() else {
            completion(.failure(.urlError))
            return
        }
        
        session.dataTask(with: urlRequest) { data, response, error in
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
    
    func requestMutiPartFormData<T: Decodable>(api: APIable, completion: @escaping (Result<T, NetworkError>) -> Void) {
        guard let urlRequest = api.makeMutiPartFormDataURLRequest() else {
            completion(.failure(.urlError))
            return
        }
        
        session.dataTask(with: urlRequest) { data, response, error in
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
