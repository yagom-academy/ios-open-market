//
//  ItemForm.swift
//  OpenMarket
//
//  Created by 최정민 on 2021/05/10.
//

import Foundation

struct PatchItemIdentityRequest: Encodable{
    var title: String?
    var descriptions: String?
    var price: Int?
    var currency: String?
    var stock: Int?
    var discountedPrice: Int?
    var images: [String]?
    var password: String
    
    private enum CodingKeys: String, CodingKey {
        case title
        case descriptions
        case price
        case currency
        case stock
        case discountedPrice = "discounted_price"
        case images
        case password
    }
}
