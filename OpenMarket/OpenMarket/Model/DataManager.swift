//
//  DataManager.swift
//  OpenMarket
//
//  Created by 배은서 on 2021/05/11.
//

import Foundation

struct DataManager {
    
    let session = URLSession.shared
    
    func decode<Decoded>(to decodeType: Decoded.Type, from data: Data) -> Decoded? where Decoded: Decodable {
        let jsonDecoder = JSONDecoder()
        
        do {
            let decoded: Decoded = try jsonDecoder.decode(Decoded.self, from: data)
            return decoded
        } catch {
            print(error)
            return nil
        }
    }
    
    func dataTask(_ requestURL: URL, completionHandler: @escaping (Data) -> Void) {
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
                completionHandler(data)
            }
            
        }.resume()
    }
    
    func requestItemList(url: URL?) {
        guard let requestURL = url else { return }
        
        dataTask(requestURL) { data in
            let itemList = decode(to: ItemList.self, from: data)
            print(itemList!)
        }
    }
    
    func requestItemDetail(url: String) {
    }
}


