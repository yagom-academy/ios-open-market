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
    
    var decodeManager = DecodeManager<ProductPage>()
    
    let url = URL(string: "https://openmarket.yagom-academy.kr")!

    func getHealthChecker() {
        let urlString = URL(string: "\(url)/healthChecker")
        var request = URLRequest(url: urlString!)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                print("Calling Error")
                print(error!)
                return
            }
            guard let safeData = data else {
                print("Receive Error")
                return
            }
            guard let response = response as? HTTPURLResponse, (200 ..< 299) ~= response.statusCode else {
                print("Request Fail Error")
                return
            }
           
            print(String(decoding: safeData, as: UTF8.self))
        }.resume()
    }
    
    func getProductList() {
        let urlString = URL(string: "\(url)/api/products?page_no=1&items_per_page=100")
        
        var request = URLRequest(url: urlString!)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                print("Calling Error")
                print(error!)
                return
            }
            guard let safeData = data else {
                print("Receive Error")
                return
            }
            guard let response = response as? HTTPURLResponse, (200 ..< 299) ~= response.statusCode else {
                print("Request Fail Error")
                return
            }
            
            let productData = self.decodeManager.decodeData(data: safeData)
            
            switch productData {
            case .success(let data):
                print(data)
            case .failure(let error):
                print(error)
            }
        }.resume()
    }
}
