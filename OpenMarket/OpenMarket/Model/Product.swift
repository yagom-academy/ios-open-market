//
//  Product.swift
//  OpenMarket
//
//  Created by Gundy, Wonbi on 2022/11/15.
//

import Foundation

struct Product: Codable {
    let id: Int
    let vendorID: Int
    let name: String
    let thumbnail: String
    let currency: Currency
    let price: Double
    let bargainPrice: Double
    let discountedPrice: Double
    let stock: Int
    let createdAt: String
    let issuedAt: String
    
    var thumbnailData: Data? {
        guard let url = URL(string: self.thumbnail),
              let data = try? Data(contentsOf: url)
        else {
            return nil
        }
        return data
    }
    
    var createdDate: Date? {
        FormatConverter.date(from: createdAt)
    }
    var issuedDate: Date? {
        FormatConverter.date(from: issuedAt)
    }
    
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

enum Currency: String, Codable {
    case krw = "KRW"
    case usd = "USD"
}
