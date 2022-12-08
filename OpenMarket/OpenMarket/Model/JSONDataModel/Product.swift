//
//  Product.swift
//  OpenMarket
//
//  Created by Ayaan, junho on 2022/11/14.
//

struct Product: Hashable, Decodable {
    let id, vendorID: Int?
    let name: String
    let thumbnail: String?
    let description: String?
    let currency: Currency
    let price, discountedPrice: Double
    let bargainPrice: Double?
    let stock: Int
    let createdAt, issuedAt: String?
    let images: [ProductImage]?
    let vendor: Vendor?
    
    private enum CodingKeys: String, CodingKey {
        case id
        case vendorID = "vendor_id"
        case name, description, thumbnail, currency, price
        case bargainPrice = "bargain_price"
        case discountedPrice = "discounted_price"
        case stock
        case createdAt = "created_at"
        case issuedAt = "issued_at"
        case images
        case vendor = "vendors"
    }
}
