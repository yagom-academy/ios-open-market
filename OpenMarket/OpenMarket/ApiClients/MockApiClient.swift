//
//  MockApiClient.swift
//  OpenMarket
//
//  Created by jost, 잼킹 on 2021/08/10.
//

import Foundation

class MockApiClient: Api, JSONDecodable {
    private static let delay = 1
    
    func getMarketPageItems(for pageNumber: Int, completion: @escaping (MarketItems?) -> Void) {
        DispatchQueue.global().asyncAfter(deadline: .now() + .seconds(MockApiClient.delay)) {
            switch pageNumber {
            case 1:
                let fileName = "Items"
                do {
                    let jsonData = try self.readLocalFile(for: fileName)
                    let items = try self.decodeJSON(MarketItems.self ,from: jsonData)
                    completion(items)
                } catch {
                    completion(nil)
                }
            default:
                completion(nil)
            }
        }
    }
    
    func getMarketItem(for id: Int, completion: @escaping (MarketItem?) -> Void) {
        DispatchQueue.global().asyncAfter(deadline: .now() + .seconds(MockApiClient.delay)) {
            switch id {
            case 1:
                let fileName = "Item"
                do {
                    let jsonData = try self.readLocalFile(for: fileName)
                    let item = try self.decodeJSON(MarketItem.self, from: jsonData)
                    completion(item)
                } catch {
                    completion(nil)
                }
            default:
                completion(nil)
            }
        }
    }
}
