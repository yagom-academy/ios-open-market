//
//  OpenMarketProduct.swift
//  OpenMarket
//
//  Created by 김민성 on 2021/05/31.
//

import Foundation

struct GetProductList: Decodable {
    
    let page: Int
    let items: [Item]
    
    struct Item: Decodable {
        let id: Int
        let title: String
        let price: Int
        let currency: String
        let stock: Int
        let discountedPrice: Int?
        let thumbnails: [String]
        let registrationDate: Double

        private enum CodingKeys: String, CodingKey {
            case id, title, price, currency, stock, thumbnails
            case discountedPrice = "discounted_price"
            case registrationDate = "registration_date"
        }
    }
}
