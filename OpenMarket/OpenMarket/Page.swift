//
//  Page.swift
//  OpenMarket
//
//  Created by BaekGom, Brad on 2022/07/11.
//

import UIKit

struct Page: Decodable {
    let id: Int
    let vendorId: Int
    let name: String
    let thumbnail: String
    let currency: String
    let price: Int
    let bargainPrice: Int
    let discountedPrice: Int
    let stock: Int
    let createdAt: String
    let issuedAt: String
}

extension Page {
    enum CodingKeys: String, CodingKey {
        case id
        case vendorId = "vendor_id"
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
    
    var image: UIImage? {
        let uiImage = UIImage(named: self.thumbnail)
        return uiImage
    }
}
