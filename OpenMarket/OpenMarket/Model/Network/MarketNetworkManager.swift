//
//  MarketNetworkManager.swift
//  OpenMarket
//
//  Created by 윤재웅 on 2021/05/15.
//

import Foundation

struct MarketNetworkManager: MarketRequest {
    private let loader: MarketNetwork
    private let decoder: Decoderable
    
    func excute<T>(request: URLRequest, decodeType: T.Type, completion: @escaping (Result<T, Error>) -> Void) where T: Decodable {
        loader.excuteNetwork(request: request) { result in
            switch result {
            case .success(let data):
                do {
                    let jsonDecode = try decoder.decode(T.self, from: data)
                    completion(.success(jsonDecode))
                } catch  {
                    completion(.failure(MarketError.decoding(error)))
                }
            case .failure(let error):
                completion(.failure(MarketError.network(error)))
            }
        }
    }
}

final class Networkloader: MarketNetwork {
    private let session: URLSession = .shared
    
    func excuteNetwork(request: URLRequest, completion: @escaping (Result<Data, Error>) -> Void) {
        session.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(MarketError.request(error)))
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                completion(.failure(MarketError.casting("HTTPURLResponse")))
                return
            }
            
            guard (200...299) ~= response.statusCode else {
                completion(.failure(MarketError.response(response.statusCode)))
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
