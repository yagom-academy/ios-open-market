//
//  NetworkManager.swift
//  OpenMarket
//
//  Created by Eddy, marisol on 2022/05/10.
//

import Foundation

enum NetworkError: Error {
    case error
    case data
    case statusCode
    case decode
}

struct NetworkManager<T: Decodable> {
    var session: URLSessionProtocol
    
    init(session: URLSessionProtocol) {
        self.session = session
    }
    
    func execute(with api: APIable, completion: @escaping (Result<T, NetworkError>) -> Void) {
        let successRange = 200...299
        
        switch api.method {
        case .get:
            session.dataTask(with: api) { response in
                guard response.error == nil else {
                    completion(.failure(.error))
                    return
                }
                
                guard successRange.contains(response.statusCode) else {
                    completion(.failure(.statusCode))
                    return
                }
                
                guard let data = response.data else {
                    completion(.failure(.data))
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
                    let result = try decoder.decode(T.self, from: data)
                    completion(.success(result))
                } catch {
                    completion(.failure(.decode))
                }
            }       
        case .post:
            print("post")
        case .put:
            print("put")
        case .delete:
            print("delete")
        }
    }
}
