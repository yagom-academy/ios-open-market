//
//  API.swift
//  OpenMarket
//
//  Created by jost, 잼킹 on 2021/08/10.
//

import Foundation

protocol Api {
    func fetchMarketItems(completion: @escaping (MarketItems?) -> Void)
}
