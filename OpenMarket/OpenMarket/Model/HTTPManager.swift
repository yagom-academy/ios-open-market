//
//  HTTPManager.swift
//  OpenMarket
//
//  Created by Ash and som on 2022/11/16.
//

import Foundation

class HTTPManager {
    static func requestGet(url: String, completion: @escaping (Data) -> ()) {
        guard let validURL = URL(string: url) else {
            return
        }
        
        var urlRequest = URLRequest(url: validURL)
        urlRequest.httpMethod = HTTPMethod.get
        
        URLSession.shared.dataTask(with: urlRequest) { data, urlResponse, error in
            guard let data = data else {
                return
            }
            
            guard let response = urlResponse as? HTTPURLResponse, (200..<300).contains(response.statusCode) else {
                if let response = urlResponse as? HTTPURLResponse {
                    print(response.statusCode)
                }
                return
            }
            
            completion(data)
        }.resume()
    }
    
    
    
    
}
