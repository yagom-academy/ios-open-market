//
//  ProductRequest.swift
//  OpenMarket
//
//  Created by Red, Mino on 2022/05/24.
//

import UIKit

struct ProductRequest: Encodable {
    var pageNumber: Int?
    var perPages: Int?
    var name: String?
    var descriptions: String?
    var price: Double?
    var currency: Currency?
    var discountedPrice: Double?
    var stock: Int?
    var secret: String?
    var imageInfos: [ImageInfo]?
    var boundary: String? = UUID().uuidString
    
    enum CodingKeys: String, CodingKey {
        case pageNumber = "page_no"
        case perPages = "items_per_page"
        case discountedPrice = "discounted_price"
        case imageInfos = "images"
        case name, descriptions, price, currency, stock, secret
    }
}

struct ImageInfo: Encodable, Hashable {
    let fileName: String
    let data: Data
    let type: String
}
