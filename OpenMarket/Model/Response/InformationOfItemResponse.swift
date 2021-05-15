//
//  PatchItemIdentityResponse.swift
//  OpenMarket
//
//  Created by 최정민 on 2021/05/11.
//

import Foundation

struct InformationOfItemResponse: Decodable, Equatable {
    var id: Int
    var title: String
    var descriptions: String
    var price: Int
    var currency: String
    var stock: Int
    var discountedPrice: Int?
    var thumbnails: [String]
    var images: [String]
    var registrationDate: Double
    
    private enum CodingKeys: String, CodingKey {
            case id, title, descriptions, price, currency, stock, thumbnails, images
            case discountedPrice = "discounted_price"
            case registrationDate = "registration_date"
        }
}

