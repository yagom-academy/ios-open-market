//
//  ProductRegistration.swift
//  OpenMarket
//
//  Created by 웡빙, 보리사랑 on 2022/07/27.
//

import Foundation
import UIKit

// MARK: - ProductRegistration
struct ProductRegistration: Codable {
    let name: String
    let descriptions: String
    let price: Int
    let currency: Currency
    let discountedPrice: Int?
    let stock: Int?
    let secret: String
    
    enum CodingKeys: String, CodingKey {
        case name
        case descriptions
        case price
        case currency
        case discountedPrice = "discounted_price"
        case stock
        case secret
    }
}
