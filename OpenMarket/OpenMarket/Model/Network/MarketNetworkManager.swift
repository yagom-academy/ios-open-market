//
//  MarketNetworkManager.swift
//  OpenMarket
//
//  Created by 윤재웅 on 2021/05/15.
//

import Foundation

struct MarketNetworkManager {
    let client: MarketNetwork
    
    func excute<T>(request: URLRequest, decodeType: T.Type, completion: @escaping (Result<T, Error>) -> Void) where T: Decodable {
        client.excuteNetwork(request: request) { result in
            switch result {
            case .failure(let error):
                completion(.failure(error))
                return
            case .success(let data):
                do {
                    let jsonDecode = try JSONDecoder().decode(T.self, from: data)
                    completion(.success(jsonDecode))
                } catch {
                    completion(.failure(MarketError.codable))
                }
            }
        }
    }
}

final class client: MarketNetwork {
    private let session: URLSession = .shared
    
    func excuteNetwork(request: URLRequest, completion: @escaping (Result<Data, Error>) -> Void) {
        session.dataTask(with: request) { data, response, error in
            guard error == nil else {
                completion(.failure(MarketError.request))
                return
            }
            
            guard let response = response as? HTTPURLResponse, (200...299) ~= response.statusCode else {
                completion(.failure(MarketError.response))
                return
            }
            
            guard let data = data else {
                completion(.failure(MarketError.data))
                return
            }
            completion(.success(data))
            
        }.resume()
    }
}
