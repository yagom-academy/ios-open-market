//
//  ProductList.swift
//  OpenMarket
//
//  Created by 데릭, 케이, 수꿍. 
//

import UIKit

struct ProductList: Codable {
    let pages: [Product]
}

enum Currency: String, Codable {
    case krw = "KRW"
    case usd = "USD"
}

struct Product: Codable {
    let id: Int
    let venderID: Int
    let name: String
    let thumbnail: String
    let currency: Currency
    let price: Double
    let bargainPrice: Double
    let discountedPrice: Double
    let stock: Int
    let createdAt: String
    let issuedAt: String
    
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
    
    var thumbnailImage: UIImage? {
        if let url = URL(string: thumbnail),
           let imageData = try? Data(contentsOf: url) {
            let image = UIImage(data: imageData)
            return image
        }
        return nil
    }
}
