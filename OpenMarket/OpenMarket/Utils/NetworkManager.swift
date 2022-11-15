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

    func getHealthChecker() {
        guard let url =
                URL(string: "\(NetworkURLAsset.host)\(NetworkURLAsset.healthChecker)") else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = HttpMethod.GET
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                print(NetworkError.networking.description)
                print(error!)
                return
            }
            guard let safeData = data else {
                print(NetworkError.data.description)
                return
            }
            guard let response = response as? HTTPURLResponse,
                    (200 ..< 299) ~= response.statusCode else {
                print(NetworkError.networking.description)
                return
            }
           
            print(String(decoding: safeData, as: UTF8.self))
        }.resume()
    }
    
    func getProductList() {
        let decodeManager = DecodeManager<ProductPage>()
        guard let url =
                URL(string: "\(NetworkURLAsset.host)\(NetworkURLAsset.productList)") else {
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
                    (200 ..< 299) ~= response.statusCode else {
                print(NetworkError.networking.description)
                return
            }
            
            let productData = decodeManager.decodeData(data: safeData)
            
            switch productData {
            case .success(let data):
                print(data)
            case .failure(let error):
                print(error)
            }
        }.resume()
    }
    
    func getProductDetail() {
        let decodeManager = DecodeManager<Product>()
        guard let url =
                URL(string: "\(NetworkURLAsset.host)\(NetworkURLAsset.productDetail)") else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = HttpMethod.GET
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                print(NetworkError.networking.description)
                print(error!)
                return
            }
            guard let safeData = data else {
                print(NetworkError.data.description)
                return
            }
            guard let response = response as? HTTPURLResponse,
                    (200 ..< 299) ~= response.statusCode else {
                print(NetworkError.networking.description)
                return
            }
            
            let productData = decodeManager.decodeData(data: safeData)
            
            switch productData {
            case .success(let data):
                print(data)
            case .failure(let error):
                print(error)
            }
        }.resume()
    }
}
