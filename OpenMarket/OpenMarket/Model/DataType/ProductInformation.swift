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
    var thumbnailImage: UIImage?

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
    
    func convertImage() -> UIImage? {
        guard let url = URL(string:thumbnail), let data = try? Data(contentsOf: url) else {
            return nil
        }
        return UIImage(data: data) ?? nil
        
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        vendorId = try container.decode(Int.self, forKey: .vendorId)
        name = try container.decode(String.self, forKey: .name)
        thumbnail = try container.decode(String.self, forKey: .thumbnail)
        currency = try container.decode(String.self, forKey: .currency)
        price = try container.decode(Double.self, forKey: .price)
        bargainPrice = try container.decode(Double.self, forKey: .bargainPrice)
        discountedPrice = try container.decode(Double.self, forKey: .discountedPrice)
        stock = try container.decode(Int.self, forKey: .stock)
        createdAt = try container.decode(String.self, forKey: .createdAt)
        issuedAt = try container.decode(String.self, forKey: .issuedAt)
        thumbnailImage = convertImage()
    }
}

