//
//  ApiClient.swift
//  OpenMarket
//
//  Created by Jost, 잼킹 on 2021/08/12.
//

import Foundation

class ApiClient: Api, JSONDecodable {
    func getMarketPageItems(for pageNumber: Int, completion: @escaping (MarketItems?) -> Void) {
        let url = "\(Config.baseUrl)/items/\(pageNumber)"
        let successRange = 200...299
        
        guard let url = URL(string: url) else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard error == nil,
                  let statusCode = (response as? HTTPURLResponse)?.statusCode,
                  successRange.contains(statusCode) else {
                return
            }
            
            guard let data = data else {
                completion(nil)
                return
            }
            
            do {
                let items: MarketItems = try self.decodeJSON(from: data)
                completion(items)
            } catch {
                completion(nil)
            }
        }.resume()
    }
    
    func getMarketItem(for id: Int, completion: @escaping (MarketItem?) -> Void) {
        let url = "\(Config.baseUrl)/item/\(id)"
        let successRange = 200...299
        
        guard let url = URL(string: url) else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard error == nil,
                  let statusCode = (response as? HTTPURLResponse)?.statusCode,
                  successRange.contains(statusCode) else {
                return
            }
            
            guard let data = data else {
                completion(nil)
                return
            }
            
            do {
                let item: MarketItem = try self.decodeJSON(from: data)
                completion(item)
            } catch {
                completion(nil)
            }
        }.resume()
    }
}
