//
//  File.swift
//  OpenMarket
//
//  Created by 김민성 on 2021/05/31.
//

import Foundation

struct OpenMarketProductDetail {
    
    let id: Int? = nil
    let title: String
    let descriptions: String
    let price: Int
    let currency: String
    let stock: Int
    let discountedPrice: Double?
    let thumbnails: [String]? = nil
    let images: [String]
    let registrationDate: Int? = nil
    let password: String? = nil
    
    private enum CodingKeys: String, CodingKey {
        case id, title, descriptions, price, currency, stock, images, thumbnails
        case discountedPrice = "discounted_price"
        case registrationDate = "registration_date"
    }
}
