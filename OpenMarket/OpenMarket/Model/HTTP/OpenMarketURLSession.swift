//
//  OpenMarketURLSession.swift
//  OpenMarket
//
//  Created by dhoney96 on 2022/07/12.
//

import Foundation

class OpenMarketURLSession {
    func getMethod(url: String, completion: @escaping (ItemList?) -> Void) {
        guard let url = URL(string: url) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                print("Error: error calling GET")
                print(error!)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                print("Error: HTTP request failed")
                return
            }
            
            guard let safeData = data else { return }
            let itemData: ItemList? = JSONDecoder.decodeJson(jsonData: safeData)
            completion(itemData)
        }
        task.resume()
    }
}
