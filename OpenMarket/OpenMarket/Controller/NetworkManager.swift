//
//  NetworkManager.swift
//  OpenMarket
//
//  Created by 박태현 on 2021/08/10.
//

import Foundation
typealias parameters = [String: Any]

class NetworkManager {
    func getItems() {
        guard let url = URL(string: "https://camp-open-market-2.herokuapp.com/items/1") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let session = URLSession.shared
        session.dataTask(with: request) { data, response, error in
            if let error = error {
                print(error.localizedDescription)
            }

            guard let response = response else { return }
            print(response)

            guard let data = data else { return }

            guard let item = try? JsonDecoder.decodedJsonFromData(type: ItemsData.self, data: data) else { return }
            print(item)
        }.resume()
    }
    
    func postItem() {
        
    }
    
    func generateBoundary() -> String {
        return "Boundary-\(UUID().uuidString)"
    }

}
