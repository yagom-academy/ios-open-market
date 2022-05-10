//
//  NetworkManager.swift
//  OpenMarket
//
//  Created by Eddy, marisol on 2022/05/10.
//

import Foundation

enum NetworkError: Error {
    case url
    case error
    case data
    case statusCode
    case decode
}

struct NetworkManager<T: Decodable> {
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func execute(with request: URLRequest, completion: @escaping (Result<T, NetworkError>) -> Void) {
        let successRange = 200...299
        
        session.dataTask(with: request) { data, response, error in
            guard error == nil else {
                completion(.failure(.error))
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode,
                  successRange.contains(statusCode) else {
                completion(.failure(.statusCode))
                return
            }
            
            guard let data = data else {
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
        }.resume()
    }
}
