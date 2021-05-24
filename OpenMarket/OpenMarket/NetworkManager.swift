//
//  NetworkManager.swift
//  OpenMarket
//
//  Created by 최정민 on 2021/05/24.
//

import Foundation

class NetworkManager {
    
    static var shared = NetworkManager()
    var isPaginating = false
    let session: URLSession
    
    init() {
        let config = URLSessionConfiguration.default
        session = URLSession(configuration: config)
    }
    
    func getItemsOfPageData(pagination: Bool, pageNumber: Int, completion: @escaping (Data?)->(Void))  {
        if pagination {
            isPaginating = true
        }
        let url = Network.baseURL + "/items/\(pageNumber)"
        guard let urlRequest = URL(string: url) else { return  }
        URLSession.shared.dataTask(with: urlRequest) { [weak self] (data, response, error) in
            self?.checkValidation(data: data, response: response, error: error)
            if pagination {
                self?.isPaginating = false
            }
            completion(data)
        }.resume()
    }
    
    private func checkValidation(data: Data?, response: URLResponse?, error: Error?) {
        if let error = error {
            fatalError("\(error)")
        }
        
        guard let httpResponse = response as? HTTPURLResponse else {
            print("Invalid Response")
            return
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            print("Status Code: \(httpResponse.statusCode)")
            return
        }
        
        guard let _ = data else {
            print("Invalid Data")
            return
        }
    }
    
}
