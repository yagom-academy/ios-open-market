//
//  Product.swift
//  OpenMarket
//  Created by inho, Hamo, Jeremy on 2022/11/15.
//

import Foundation

struct ProductData: Decodable {
    let identifier: Int
    let vendorIdentifier: Int
    let name: String
    let thumbnail: String
    let currency: String
    let price: Int
    let bargainPrice: Int
    let discountedPrice: Int
    let stock: Int
    let createdDate: String
    let issuedDate: String
    
    enum CodingKeys: String, CodingKey {
        case identifier = "id"
        case vendorIdentifier = "vendor_id"
        case name
        case thumbnail
        case currency
        case price
        case bargainPrice = "bargain_price"
        case discountedPrice = "discounted_price"
        case stock
        case createdDate = "created_at"
        case issuedDate = "issued_at"
    }
}
