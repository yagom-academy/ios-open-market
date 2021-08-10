//
//  API.swift
//  OpenMarket
//
//  Created by jost, 잼킹 on 2021/08/10.
//

import Foundation

protocol Api {}

protocol MockApi: Api {
    func getMarketPageItems(for pageNumber: Int, completion: @escaping (MarketItems?) -> Void)
    func getMarketItem(for id: Int, completion: @escaping (MarketItem?) -> Void)
}

protocol ProdApi: MockApi {
    func createMarketItem(for item: RequestMarketItem, completion: @escaping (MarketItem?) -> Void)
    func updateMarketItem(for id: Int, with item: RequestMarketItem, completion: @escaping (MarketItem?) -> Void)
    func deleteMarketItem(for id: Int, with password: String, completion: @escaping (MarketItem?) -> Void)
}
