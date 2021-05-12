//
//  MarketItem.swift
//  OpenMarket
//
//  Created by Fezz, Tak on 2021/05/12.
//

import Foundation

struct MarketItem: ProductInfo, ProductDetail {
    let id: UInt
    let title: String
    let descriptions: String
    let price: UInt
    let currency: String
    let stock: UInt
    let discountedPrice: UInt?
    let thumbnails: [String]
    let images: [String]
    let registrationData: Double
    
    enum CodingKeys: String, CodingKey {
        case id, title, descriptions, price, currency, stock, thumbnails, images
        case discountedPrice = "discounted_price"
        case registrationData = "registration_data"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = (try? container.decode(UInt.self, forKey: .id)) ?? 0
        self.title = (try? container.decode(String.self, forKey: .title)) ?? ""
        self.descriptions = (try? container.decode(String.self, forKey: .descriptions)) ?? ""
        self.price = (try? container.decode(UInt.self, forKey: .price)) ?? 0
        self.currency = (try? container.decode(String.self, forKey: .currency)) ?? ""
        self.stock = (try? container.decode(UInt.self, forKey: .stock)) ?? 0
        self.discountedPrice = (try? container.decode(UInt?.self, forKey: .discountedPrice)) ?? 0
        self.thumbnails = (try? container.decode([String].self, forKey: .thumbnails)) ?? []
        self.images = (try? container.decode([String].self, forKey: .images)) ?? []
        self.registrationData = (try? container.decode(Double.self, forKey: .registrationData)) ?? 0.0
    }
}
