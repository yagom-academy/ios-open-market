//
//  NetworkManager.swift
//  OpenMarket
//  Created by inho, Hamo, Jeremy on 2022/11/15.
//

import Foundation

struct NetworkManager {
    func loadData(of url: URL?, completion: @escaping (Data?) -> Void ) {
        guard let url = url else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard error == nil else { return }
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode)
            else {
                return
            }
            guard let data = data else { return }
        
            completion(data)
        }.resume()
    }
}
