//
//  NetworkCommunication.swift
//  OpenMarket
//
//  Created by Mangdi, Woong on 2022/11/16.
//

import Foundation

struct NetworkCommunication {
    let session = URLSession(configuration: .default)
    
    func requestHealthChecker(url: String) {
        guard let url: URL = URL(string: url) else { return }
        
        let task: URLSessionDataTask = session.dataTask(with: url) { _, response, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            if let response = response as? HTTPURLResponse {
                print(response.statusCode)
            }
        }
        task.resume()
    }
    
    func requestProductsInformation<T: Decodable>(url: String, type: T.Type) {
        guard let url: URL = URL(string: url) else { return }
        
        let task: URLSessionDataTask = session.dataTask(with: url) { data, _, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let data = data else { return }
            
            do {
                let decodingData = try JSONDecoder().decode(type.self, from: data)
                if type == SearchListProducts.self {
                    guard let searchListProducts = decodingData as? SearchListProducts else { return }
                    print(searchListProducts.pages[0])
                } else {
                    print(decodingData)
                }
            } catch {
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
}
