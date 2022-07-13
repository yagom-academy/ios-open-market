//
//  JSONParser.swift
//  OpenMarket
//
//  Created by BaekGom, Brad on 2022/07/12.
//

import Foundation

struct JSONParser {
    
    func fetch(by url: String, completion: @escaping (Result<Any, Error>) -> ()) {
        guard let url = URL(string: url) else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if let data = data {
                do {
                    let decodeData = try JSONDecoder().decode(Product.self, from: data)
                    completion(.success(decodeData))
                }
                catch {
                    print(error.localizedDescription)
                }
            }
        }
        task.resume()
    }
}
