//
//  Item.swift
//  OpenMarket
//
//  Created by Ash and som on 2022/11/15.
//

struct Item: Codable {
    let id: Int
    let vendorID: Int
    let name, description: String
    let vendorName: String?
    let thumbnail: String
    let currency: Currency
    let price, bargainPrice, discountedPrice: Double
    let stock: Int
    let createdAt, issuedAt: String

    enum CodingKeys: String, CodingKey {
        case id
        case vendorID = "vendor_id"
        case name, thumbnail, currency, price, vendorName, description
        case bargainPrice = "bargain_price"
        case discountedPrice = "discounted_price"
        case stock
        case createdAt = "created_at"
        case issuedAt = "issued_at"
    }
}
