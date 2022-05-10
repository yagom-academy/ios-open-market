//
//  Item.swift
//  OpenMarket
//
//  Created by Red, Mino. on 2022/05/10.
//

struct Page: Codable {
    let id, vendorID: Int
    let name: String
    let thumbnail: String
    let currency: String
    let price, bargainPrice, discountedPrice: Double
    let stock: Int
    let createdAt, issuedAt: String

    enum CodingKeys: String, CodingKey {
        case id
        case vendorID = "vendor_id"
        case name, thumbnail, currency, price
        case bargainPrice = "bargain_price"
        case discountedPrice = "discounted_price"
        case stock
        case createdAt = "created_at"
        case issuedAt = "issued_at"
    }
}
