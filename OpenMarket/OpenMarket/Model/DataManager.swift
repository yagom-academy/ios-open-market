//
//  DataManager.swift
//  OpenMarket
//
//  Created by 배은서 on 2021/05/11.
//

import Foundation

struct DataManager {
    
    func requestItemList(url: String) {
        let session = URLSession.shared
        guard let requestURL = URL(string: url) else { return }
        
        session.dataTask(with: requestURL) { data, response, error in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            
            guard let response = response as? HTTPURLResponse,
                  (200...299).contains(response.statusCode) else {
                print("response")
                return
            }
            
            if let mimeType = response.mimeType, mimeType == "application/json",
               let data = data {
                do {
                    let itemListResponse = try JSONDecoder().decode(ItemList.self, from: data)
                    print(itemListResponse)
                } catch(let error) {
                    print(error.localizedDescription)
                }
            }
        
        }.resume()
    }
}


