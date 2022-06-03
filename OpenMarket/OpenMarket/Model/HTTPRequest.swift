//
//  HTTPRequest.swift
//  OpenMarket
//
//  Created by Eddy, marisol on 2022/05/29.
//

import Foundation

struct ProductForPOST: Encodable {
    let name: String?
    let descriptions: String?
    let price: Int?
    let currency: Currency?
    let discountedPrice: Int?
    let stock: Int?
    let secret: String?
    
    private enum CodingKeys: String, CodingKey {
        case name, descriptions, price, currency, stock, secret
        case discountedPrice = "discounted_price"
    }
}

struct ProductForPATCH: Encodable {
    let name: String?
    let descriptions: String?
    let thumbnailID: Int?
    let price: Int?
    let currency: Currency?
    let discountedPrice: Int?
    let stock: Int?
    let secret: String?
    
    private enum CodingKeys: String, CodingKey {
        case name, descriptions, price, currency, stock, secret
        case thumbnailID = "thumbnail_id"
        case discountedPrice = "discounted_price"
    }
}
