//
//  NetworkManager.swift
//  OpenMarket
//
//  Created by Kyo, LJ on 2022/11/15.
//

import Foundation

final class NetworkManager {
    static let shared = NetworkManager()
    private init() {}
    
    func checkHealth() {
        guard let url =
                URL(string: "\(NetworkURLAsset.host)\(NetworkURLAsset.healthChecker)") else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = HttpMethod.GET
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                print(NetworkError.networking.description)
                return
            }
            
            guard let safeData = data else {
                print(NetworkError.data.description)
                return
            }             
            
            guard let response = response as? HTTPURLResponse,
                  200 == response.statusCode else {
                print(NetworkError.networking.description)
                return
            }
            
            print(String(decoding: safeData, as: UTF8.self))
        }.resume()
    }
    
    func fetchData<T: Decodable>(to networkAsset: String,
                                 dataType: T.Type,
                                 completion: @escaping (Result<T, NetworkError>) -> Void) {
        
        let decodeManager = DecodeManager<T>()
        
        guard let url =
                URL(string: "\(NetworkURLAsset.host)\(networkAsset)") else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = HttpMethod.GET
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                completion(.failure(.networking))
                return
            }
            
            guard let safeData = data else {
                completion(.failure(.data))
                return
            }
            
            guard let response = response as? HTTPURLResponse,
                  (200 ..< 299) ~= response.statusCode else {
                completion(.failure(.networking))
                return
            }
            
            if networkAsset == NetworkURLAsset.productDetail {
                let productData = decodeManager.decodeData(data: safeData)
                switch productData {
                case .success(let data):
                    completion(.success(data))
                case .failure(let error):
                    completion(.failure(error))
                }
            } else {
                let productData = decodeManager.decodeData(data: safeData)
                switch productData {
                case .success(let data):
                    completion(.success(data))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }.resume()
    }
}
