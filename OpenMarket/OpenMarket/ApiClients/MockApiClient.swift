//
//  MockApiClient.swift
//  OpenMarket
//
//  Created by jost, 잼킹 on 2021/08/10.
//

import Foundation

class MockApiClient: Api, JSONDecodable {
    private static let delay = 1
    
    func getMarketItems(for page: Int, completion: @escaping (MarketItems?) -> Void) {
        DispatchQueue.global().asyncAfter(deadline: .now() + .seconds(MockApiClient.delay)) {
            switch page {
            case 1:
                let fileName = "Items"
                do {
                    let jsonData = try self.readLocalFile(for: fileName)
                    let items: MarketItems = try self.decodeJSON(from: jsonData)
                    completion(items)
                } catch {
                    completion(nil)
                }
            default:
                completion(nil)
            }
            
        }
    }
}
