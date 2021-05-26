//
//  OpenMarketItem.swift
//  OpenMarket
//
//  Created by TORI on 2021/05/10.
//

import Foundation

struct Product: Codable {
    let id: Int
    let title: String
    let price: Int
    let currency: String
    let stock: Int
    let discountedPrice: Int?
    let thumbnails: [String]
    let images: [String]?
    let registrationDate: Double
    
    enum CodingKeys: String, CodingKey {
        case id, title, price, currency, stock, thumbnails, images
        case discountedPrice = "discounted_price"
        case registrationDate = "registration_date"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(Int.self, forKey: .id)
        title = try values.decode(String.self, forKey: .title)
        price = try values.decode(Int.self, forKey: .price)
        currency = try values.decode(String.self, forKey: .currency)
        stock = try values.decode(Int.self, forKey: .stock)
        discountedPrice = try values.decodeIfPresent(Int.self, forKey: .discountedPrice)
        thumbnails = try values.decode([String].self, forKey: .thumbnails)
        images = try values.decodeIfPresent([String].self, forKey: .images)
        registrationDate = try values.decode(Double.self, forKey: .registrationDate)
    }
}
