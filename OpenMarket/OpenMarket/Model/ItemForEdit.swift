//
//  ItemForEdit.swift
//  OpenMarket
//
//  Created by 배은서 on 2021/05/11.
//

import Foundation

struct ItemForEdit: Codable {
    let title: String?
    let descriptions: String?
    let currency: String?
    let stock: Int?
    let discountedPrice: Double?
    let images: [String]?
    let password: String
    
    enum CodingKeys: String, CodingKey {
        case title, descriptions, currency, stock, images, password
        case discountedPrice = "discounted_price"
    }
}
