//
//  OpenMarketService.swift
//  OpenMarket
//
//  Created by 허윤영 on 10/05/2022.
//

import Foundation

struct OpenMarketService: Decodable {
    let products: [Product]
    
    enum CodingKeys: String, CodingKey {
        case products = "pages"
    }
    
    init(products: [Product] = []) {
        self.products = products
    }
}
