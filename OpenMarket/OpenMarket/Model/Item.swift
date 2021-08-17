//
//  ItemListPage.swift
//  OpenMarket
//
//  Created by yun on 2021/08/12.
//

import Foundation

class Item: Decodable {
    let id: Int
    let title: String
    var descriptions: String?
    let price: Int
    var discountedPrice: Int?
    let currency: String
    let stock: Int
    let thumbnails: [String]
    var images: [String]?
    let registrationDate: Date
    
    private enum CodingKeys: String, CodingKey {
        case id, title, descriptions, price, currency, stock, thumbnails, images
        case discountedPrice = "discounted_price"
        case registrationDate = "registration_date"
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.title = try container.decode(String.self, forKey: .title)
        self.descriptions = try? container.decode(String.self, forKey: .descriptions)
        self.price = try container.decode(Int.self, forKey: .price)
        self.discountedPrice = try? container.decode(Int.self, forKey: .discountedPrice)
        self.currency = try container.decode(String.self, forKey: .currency)
        self.stock = try container.decode(Int.self, forKey: .stock)
        self.thumbnails = try container.decode([String].self, forKey: .thumbnails)
        self.images = try? container.decode([String].self, forKey: .images)
        let epochTime = try container.decode(Double.self, forKey: .registrationDate)
        self.registrationDate = Date(timeIntervalSince1970: epochTime)
    }
}
