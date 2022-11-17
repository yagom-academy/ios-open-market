//
//  NetworkManager.swift
//  OpenMarket
//  Created by inho, Hamo, Jeremy on 2022/11/15.
//

import Foundation

struct NetworkManager {
    private let session: URLSessionProtocol
    
    init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }
    
    func loadData<T: Decodable>(of request: NetworkRequest, dataType: T.Type, completion: @escaping (Result<T, Error>) -> Void) {
        guard let url = request.url else { return }
        
        session.dataTask(with: url) { data, response, error in
            guard error == nil else {
                completion(.failure(OpenMarketError.transportError))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode)
            else {
                completion(.failure(OpenMarketError.serverError))
                return
            }
            
            guard let data = data else {
                completion(.failure(OpenMarketError.missingData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                
                let data = try decoder.decode(T.self, from: data)
                completion(.success(data))
            } catch {
                completion(.failure(OpenMarketError.failedToParse))
            }
        }.resume()
    }
}
