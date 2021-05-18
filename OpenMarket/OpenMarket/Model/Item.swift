//
//  Item.swift
//  OpenMarket
//
//  Created by 김찬우 on 2021/05/13.
//

import Foundation

struct Item: Codable, Equatable {
    var id: Int
    var title: String
    var descriptions: String?
    var price: Int
    var currency: String
    var stock: Int
    var thumbnails: [String]
    var images: [String]?
    var registration_date: Double
}
