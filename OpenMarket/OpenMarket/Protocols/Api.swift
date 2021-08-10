//
//  API.swift
//  OpenMarket
//
//  Created by jost, 잼킹 on 2021/08/10.
//

import Foundation

protocol Api {
    func getMarketItems(for page: Int, completion: @escaping (MarketItems?) -> Void)
}
