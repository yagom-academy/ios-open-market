//
//  Product.swift
//  OpenMarket
//
//  Created by 케이, 수꿍 on 2022/07/11.
//

import UIKit

struct Product: Codable {
    let id: Int
    let venderID: Int
    let name: String
    let thumbnail: String
    let currency: String
    let price: Int
    let bargainPrice: Int
    let discountedPrice: Int
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
