//
//  Product.swift
//  OpenMarket
//
//  Created by Baemini on 2022/11/14.
//

struct Product: Decodable {
    let id, sellerId, stock: Int
    let price, bargainPrice, discountedPrice: Double
    let name, thumbnail: String
    let sellerName: String?
    let description: String?
    let currency: Currency
    let createdDate: String
    let issuedDate: String
    
    enum CodingKeys: String, CodingKey {
        case id, name, thumbnail, description, currency, price, stock
        case sellerId = "vendor_id"
        case sellerName = "vendorName"
        case bargainPrice = "bargain_price"
        case discountedPrice = "discounted_price"
        case createdDate = "created_at"
        case issuedDate = "issued_at"
    }
    
    var originPriceStringValue: String {
        return "\(currency.rawValue) \(price.description)"
    }
    
    var bargainPriceStringValue: String {
        return "\(currency.rawValue) \(bargainPrice.description)"
    }
}
