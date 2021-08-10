//
//  ThumbnailProduct.swift
//  OpenMarket
//
//  Created by Kim Do hyung on 2021/08/10.
//

import Foundation

struct ThumbnailProduct: Codable {
    var id: Int
    var title: String
    var price: Int
    var currency: String
    var stock: Int
    var thumbnails: [String]
    var registrationDate: Double
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case price
        case currency
        case stock
        case thumbnails
        case registrationDate = "registration_date"
    }
}
