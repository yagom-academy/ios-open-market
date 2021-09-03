//
//  Item.swift
//  OpenMarket
//
//  Created by 이윤주 on 2021/09/02.
//

import Foundation

struct Item: Decodable {
    let id: Int
    let title: String
    let descriptions: String?
    let price: Int
    let discountedPrice: Int?
    let currency: String
    let stock: Int
    let thumbnails: [String]
    let images: [String]?
    let registrationDate: Double
}
