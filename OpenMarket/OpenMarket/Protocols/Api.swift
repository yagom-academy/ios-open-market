//
//  API.swift
//  OpenMarket
//
//  Created by jost, 잼킹 on 2021/08/10.
//

import Foundation

protocol Api {
    func getMarketPageItems(for pageNumber: Int, completion: @escaping (MarketItems?) -> Void)
    
    func getMarketItem(for id: Int, completion: @escaping (MarketItem?) -> Void)
}
