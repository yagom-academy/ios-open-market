//
//  Product.swift
//  OpenMarket
//
//  Created by Baemini on 2022/11/14.
//

import Foundation

struct Product: Decodable {
    let id: Int
    let vendor_id: Int
    let name: String
    let description: String
    let thumbnail: String
    let currency: Currency
    let price: Int
    let bargain_price: Int
    let discounted_price: Int
    let stock: Int
    let created_at: Date
    let issued_at: Date
}
