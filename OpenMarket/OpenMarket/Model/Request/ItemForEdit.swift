//
//  ItemForEdit.swift
//  OpenMarket
//
//  Created by Hailey, Ryan on 2021/05/11.
//

import Foundation

struct ItemForEdit: Codable {
    let title: String?
    let price: Int?
    let descriptions: String?
    let currency: String?
    let stock: Int?
    let discountedPrice: Int?
    let images: [Data]?
    let password: String
    
    private enum CodingKeys: String, CodingKey {
        case title, price, descriptions, currency, stock, images, password
        case discountedPrice = "discounted_price"
    }
}
