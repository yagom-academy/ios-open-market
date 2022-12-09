//
//  DetailProduct.swift
//  OpenMarket
//
//  Created by Gundy, Wonbi on 2022/12/07.
//

struct DetailProduct: Codable {
    let id, vendorID: Int
    let name, description: String
    let thumbnail: String
    let currency: Currency
    let price, bargainPrice, discountedPrice: Double
    let stock: Int
    let createdAt, issuedAt: String
    let images: [Image]
    let vendors: Vendor

    enum CodingKeys: String, CodingKey {
        case id
        case vendorID = "vendor_id"
        case name, description, thumbnail, currency, price
        case bargainPrice = "bargain_price"
        case discountedPrice = "discounted_price"
        case stock
        case createdAt = "created_at"
        case issuedAt = "issued_at"
        case images, vendors
    }
}
