//
//  Product.swift
//  OpenMarket
//
//  Created by Gordon Choi on 2022/07/11.
//

import Foundation
import UIKit

struct Products: Codable, Equatable {
    let pages: [Product]
}

struct Product: Codable, Equatable {
    let id: Int
    let vendorId: Int
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
        case id
        case vendorId = "vendor_id"
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
    
    var thumbnailImage: UIImage? {
        if let url = URL(string: thumbnail),
           let imageData = try? Data(contentsOf: url) {
            let image = UIImage(data: imageData)
            return image
        }
        return nil
    }
}
