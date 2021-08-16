//
//  PatchMarketItem.swift
//  OpenMarket
//
//  Created by Jost, 잼킹 on 2021/08/11.
//

import Foundation

struct DeleteMarketItem: Codable {
    var password: String
    
    init(deleteKey password: String) {
        self.password = password
    }
}
