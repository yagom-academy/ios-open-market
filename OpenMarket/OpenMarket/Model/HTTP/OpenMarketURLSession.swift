//
//  OpenMarketURLSession.swift
//  OpenMarket
//
//  Created by dhoney96 on 2022/07/12.
//

import Foundation

class OpenMarketURLSession {
    let baseURL = "{{api-host}}/"
    let session = URLSession(configuration: .default)
    
    func dataTask(url: String) {
        guard let url = URL(string: "\(baseURL) + \(url)") else { return }
        let request = URLRequest(url: url)
        
        let task = session.dataTask(with: request) { data, response, error in
            guard error == nil else {
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                return
            }
            
            guard let safeData = data else { return }
        }
        task.resume()
    }
}
