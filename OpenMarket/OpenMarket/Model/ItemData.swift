//
//  ItemData.swift
//  OpenMarket
//
//  Created by tae hoon park on 2021/08/10.
//

import Foundation

struct itemData: Codable {
    let id: Int
    let title: String
    let descriptions: String
    let price: Int
    let currency: String
    let stock: Int
    let thumbnails: [String]
    let images: [String]
    let registrationDate: String
    
    enum Codingkeys: String, CodingKey {
        case id
        case title
        case descriptions
        case price
        case currency
        case stock
        case thumbnails
        case images
        case registraionDate = "registration_date"
    }
}
