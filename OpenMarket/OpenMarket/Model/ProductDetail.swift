//
//  ProductDetail.swift
//  OpenMarket
//
//  Created by 김동용 on 2022/07/12.
//

import Foundation

struct ProductDetail: Decodable {
    private(set) var id: Int
    private(set) var venderID: Int
    private(set) var name: String
    private(set) var thumbnail: String
    private(set) var currency: String
    private(set) var price: Int
    private(set) var bargainPrice: Int
    private(set) var discountedPrice: Int
    private(set) var stock: Int
    private(set) var createdAt: Date
    private(set) var issuedAt: Date
    
    enum CodingKeys: String, CodingKey {
        case id
        case venderID = "vendor_id"
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
