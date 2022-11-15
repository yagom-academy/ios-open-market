//
//  Page.swift
//  OpenMarket
//
//  Created by Ash and som on 2022/11/15.
//

struct Page: Codable {
    let id, vendorID: Int
    let name: Name
    let thumbnail: String
    let currency: Currency
    let price, bargainPrice, discountedPrice, stock: Int
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
