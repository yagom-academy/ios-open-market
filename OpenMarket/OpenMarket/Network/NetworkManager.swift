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

struct NetworkManager<T: Codable> {
    private let session: URLSession
    
    init(session: URLSession = .customSession) {
        self.session = session
    }
    
    func checkServerState(completion: @escaping (Result<String, NetworkErorr>) -> Void) {
        guard let urlRequst = EndPoint.serverState(httpMethod: .get).urlRequst else {
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
    
    func request(endPoint: EndPoint, completion: @escaping (Result<T, NetworkErorr>) -> Void) {
        guard let urlRequst = endPoint.urlRequst else {
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
