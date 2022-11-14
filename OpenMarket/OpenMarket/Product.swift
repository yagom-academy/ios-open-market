//
//  Product.swift
//  OpenMarket
//
//  Created by Ayaan, junho on 2022/11/14.
//

struct Product: Decodable {
    let id, vendorID: Int
    let name, thumbnail: String
    let description: String?
    let currency: Currency
    let price, bargainPrice, discountedPrice: Double
    let stock: Int
    let createdAt, issuedAt: String
    
    private enum CodingKeys: String, CodingKey {
        case id
        case vendorID = "vendor_id"
        case name, description, thumbnail, currency, price
        case bargainPrice = "bargain_price"
        case discountedPrice = "discounted_price"
        case stock
        case createdAt = "created_at"
        case issuedAt = "issued_at"
    }
}
