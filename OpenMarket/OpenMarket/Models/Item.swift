//
//  Item.swift
//  OpenMarket
//
//  Created by 스톤, 로빈 on 2022/11/15.
//
struct Item: Codable {
    let id, vendorId: Int
    let vendorName, name, pageDescription: String
    let thumbnail: String
    let currency: Currency
    let price, bargainPrice, discountedPrice: Double
    let stock: Int
    let createdAt, issuedAt: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case vendorId = "vendor_id"
        case vendorName, name
        case pageDescription = "description"
        case thumbnail, currency, price
        case bargainPrice = "bargain_price"
        case discountedPrice = "discounted_price"
        case stock
        case createdAt = "created_at"
        case issuedAt = "issued_at"
    }
}
