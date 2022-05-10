//
//  Item.swift
//  OpenMarket
//
//  Created by Red, Mino. on 2022/05/10.
//

struct Item: Codable {
    let id: Int
    let name: String
    let thumbnail: String
    let currency: String
    let price: String
    let bargainPrice: String
    let discountedPrice: String
    let stock: Int
    let createdAt: String
    let issuedAt: String
    
    enum Codingkeys: String, CodingKey {
        case id
        case name
        case thumbnail
        case currency
        case price
        case bargainPrice = "bargain_price"
        case discountedPrice = "discounted_price"
        case stock
        case createdAt = "created_at"
        case issuedAt = "issued_at"
    }
}
