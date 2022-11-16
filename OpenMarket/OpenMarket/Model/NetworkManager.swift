//
//  NetworkManager.swift
//  OpenMarket
//  Created by inho, Hamo, Jeremy on 2022/11/15.
//

import Foundation

struct NetworkManager {
    func loadData(of request: NetworkRequest, completion: @escaping (Result<Data, Error>) -> Void) throws {
        guard let url = request.url else {
            throw OpenMarketError.invalidURL
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
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
            
            completion(.success(data))
        }.resume()
    }
}
