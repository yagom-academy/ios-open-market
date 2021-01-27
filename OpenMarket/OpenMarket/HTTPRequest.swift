//
//  HTTPRequest.swift
//  OpenMarket
//
//  Created by Zero DotOne on 2021/01/27.
//

import Foundation

struct HTTPRequest {
    let url: String = "https://camp-open-market.herokuapp.com/images/1"
    
    func request() throws {
        let session = URLSession.shared
        
        guard let url = URL(string: url) else {
            throw NetworkError.urlCreationFailed
        }
        
        session.dataTask(with: url) { data, response, error in
            if let error = error {
                print(error)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                return
            }
            
            if let data = data {
                do {
                    let decodedData = try JSONDecoder().decode(ItemList.self, from: data)
                    print(decodedData)
                } catch {
                    print(error)
                }
            }
        }
    }
}

enum NetworkError: Error {
    case urlCreationFailed
}
