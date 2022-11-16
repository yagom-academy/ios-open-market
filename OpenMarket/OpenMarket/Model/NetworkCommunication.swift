//
//  NetworkCommunication.swift
//  OpenMarket
//
//  Created by Mangdi on 2022/11/16.
//

import Foundation

class NetworkCommunication {
    var searchListProducts: SearchListProducts?
    
    func requestHealthChecker(url: String) {
        let session = URLSession(configuration: .default)
        guard let url: URL = URL(string: url) else { return }
        
        let task: URLSessionDataTask = session.dataTask(with: url) { data, response, error in
            if let error = error {
                // 코드 수정하기
                print(error.localizedDescription)
                return
            }
            
            if let response = response as? HTTPURLResponse {
                print(response.statusCode)
            }
        }
        task.resume()
    }
    
    func requestSearchListProducts(url: String) {
        let session = URLSession(configuration: .default)
        guard let url: URL = URL(string: url) else { return }
        
        let task: URLSessionDataTask = session.dataTask(with: url) { data, response, error in
            if let error = error {
                // 코드 수정하기
                print(error.localizedDescription)
                return
            }
            
            if let response = response as? HTTPURLResponse {
                print(response.statusCode)
            }
            
            guard let data = data else { return }
            
            do {
                self.searchListProducts = try JSONDecoder().decode(SearchListProducts.self, from: data)
            } catch {
                print(error.localizedDescription)
            }

        }
        task.resume()
    }
}
