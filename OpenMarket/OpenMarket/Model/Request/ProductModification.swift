//
//  ProductModification.swift
//  OpenMarket
//
//  Created by Ari on 2022/01/04.
//

import Foundation

struct ProductModification: Codable {
    let secret: String
    let name: String?
    let descriptions: String?
    let thumbnailID: Int?
    let price: Double?
    let currency: Currency?
    let discountedPrice: Double?
    let stock: Int?
    
    enum CodingKeys: String, CodingKey {
        case secret, name, descriptions, price, currency, stock
        case thumbnailID = "thumbnail_id"
        case discountedPrice = "discounted_price"
    }
}

extension ProductModification {
    init(secert: String) {
        self.secret = secert
        self.name = nil
        self.descriptions = nil
        self.thumbnailID = nil
        self.price = nil
        self.currency = nil
        self.discountedPrice = nil
        self.stock = nil
    }
}
