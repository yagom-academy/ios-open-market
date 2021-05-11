//
//  MarketData.swift
//  OpenMarket
//
//  Created by Sunny, James on 2021/05/11.
//

import Foundation

//let url = "https://camp-open-market-2.herokuapp.com/"

struct MarketItemList: Decodable {
    let page: Int
    let items: [Items]
}

struct Items: Decodable {
    let id: Int
    let title: String
    let price: Int
    let currency: String
    let stock: Int
//    let descriptions: String
//    let discountedPrice: Int?
    let thumbnails: [String]
    let registrationDate: Double
    
    private enum CodingKeys: String, CodingKey {
        case id
        case title
        case price
        case currency
        case stock
//        case descriptions
//        case discountedPrice = "discounted_price"
        case thumbnails
        case registrationDate = "registration_date"
    }
}

//struct MarketItem: Codable {
//    let id: Int
//    let title: String
//    let descriptions: String
//    let price: Int
//    let currency: String
//    let stock: Int
//    let discountedPrice: Int?
//    let thumbnails: [String]
//    let images: [String]
//    let registrationData: Double
//    
//    private enum CodingKeys: String, CodingKey {
//        case id
//        case title
//        case descriptions
//        case price
//        case currency
//        case stock
//        case discountedPrice = "discounted_price"
//        case thumbnails
//        case images
//        case registrationData = "registration_date"
//    }
//}

