//
//  NetworkManager.swift
//  OpenMarket
//
//  Created by 박태현 on 2021/08/31.
//

import Foundation

struct NetworkManager {
    private let session: URLSession
    
    init(session: URLSession) {
        self.session = session
    }
    
    func commuteWithAPI(with url: String) {
        guard let url = URL(string: url) else {
            return
        }
        let request = URLRequest(url: url)
        
        session.dataTask(with: request) { data, response, error in
            if let error = error {
                print("error")
                return
            }
            guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                print("invalid response")
                return
            }
            
            if let data = data, let response = try? JSONDecoder().decode(Items.self, from: data) {
                return
            }
        }.resume()
    }
}
