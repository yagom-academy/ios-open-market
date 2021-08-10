//
//  Product.swift
//  OpenMarket
//
//  Created by 김준건 on 2021/08/10.
//

import Foundation

struct Product {
    let id: Int
    let title: String
    var description: String?
    let price: Int
    let currency: String
    let stock: UInt
    let discountedPrice: Int?
    let thumbnails: [String]
    var images: [String]?
}
