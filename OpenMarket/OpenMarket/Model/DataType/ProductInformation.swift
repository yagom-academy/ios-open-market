//
//  ProductInformation.swift
//  OpenMarket
//
//  Created by 우롱차, Donnie on 2022/05/10.
//

import Foundation
import UIKit

struct ProductInformation: Codable, Equatable, Hashable {
    let id: Int
    let vendorId: Int
    let name: String
    let thumbnail: String
    let currency: String
    let price: Double
    let bargainPrice: Double
    let discountedPrice: Double
    let stock: Int
    let createdAt: String
    let issuedAt: String
    var thumbnailImage: UIImage? {
        get {
        guard let url = URL(string:thumbnail), let data = try? Data(contentsOf: url) else {
            return nil
        }
        return UIImage(data: data) ?? nil
        }
    }

    private enum CodingKeys: String, CodingKey {
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
}

