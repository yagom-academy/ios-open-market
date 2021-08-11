//
//  Item.swift
//  OpenMarket
//
//  Created by Luyan, Ellen on 2021/08/10.
//

import Foundation

struct Item: Codable {
    let id: Int
    let title: String
    let descriptions: String?
    let price: Int
    let currency: String
    let stock: Int
    let discountedPrice: Int?
    let thumbnails: [String]
    let images: [String]?
    let registrationDate: Double
}
