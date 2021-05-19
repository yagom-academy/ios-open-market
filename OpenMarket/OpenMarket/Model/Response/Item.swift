//
//  Item.swift
//  OpenMarket
//
//  Created by Hailey, Ryan on 2021/05/11.
//

struct Item: Decodable, Equatable {
    let id: Int
    let title: String
    let price: Double
    let currency: String
    let stock: Int
    let discountedPrice: Double?
    let thumbnails: [String]
    let registrationDate: Double
    
    private enum CodingKeys: String, CodingKey {
        case id, title, price, currency, stock, thumbnails
        case discountedPrice = "discounted_price"
        case registrationDate = "registration_date"
    }
}
