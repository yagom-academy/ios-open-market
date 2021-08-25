//
//  ItemListPage.swift
//  OpenMarket
//
//  Created by yun on 2021/08/12.
//

import Foundation

struct Item: Decodable {
    let id: Int
    let title: String
    let descriptions: String?
    let price: Int
    let discountedPrice: Int?
    let currency: String
    var stock: Int
    let thumbnails: [String]
    let images: [String]?
    let registrationDate: Double
}
