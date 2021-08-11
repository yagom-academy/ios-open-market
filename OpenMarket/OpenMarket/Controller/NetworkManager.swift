//
//  NetworkManager.swift
//  OpenMarket
//
//  Created by 박태현 on 2021/08/10.
//

import Foundation

class NetworkManager {
    func getItems() {
        guard let url = URL(string: "https://camp-open-market-2.herokuapp.com/items/1") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let session = URLSession.shared
        let task = session.dataTask(with: url) { data, response, error in
            if let error = error {
                print(error)
            }
            
            guard let data = data else { return }

            if let item = try? JSONDecoder().decode(ItemsData.self, from: data) {
                print(item)
            } else {
                print("Invalid Response")
            }
        }
        task.resume()
    }
}
