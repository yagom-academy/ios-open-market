//
//  MarketItem.swift
//  OpenMarket
//
//  Created by Kyungmin Lee on 2021/01/26.
//

import Foundation

struct MarketItem: Decodable {
    let id: Int
    let title: String?
    let descriptions: String?
    private let price: Int?
    private let currency: String?
    let stock: Int?
    let discountedPrice: Int?
    let thumbnails: [String]?
    let images: [String]?
    private let registrationDate: Double?

    var priceWithCurrency: String {
        let numberFormatter: NumberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.currencyCode = self.currency
        guard let result: String = numberFormatter.string(for: price) else {
            fatalError("Variable can't convert formatted string.")
        }
        return numberFormatter.currencyCode + " " + result
    }
    var registrationGMTDate: String {
        guard let registrationDate = self.registrationDate else {
            fatalError("Did not exist registration date data.")
        }
        let date: Date = Date(timeIntervalSince1970: registrationDate)
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        dateFormatter.locale = NSLocale.autoupdatingCurrent
        dateFormatter.dateFormat = "yyyy.MM.dd HH:MM"
        return dateFormatter.string(from: date)
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case descriptions
        case price
        case currency
        case stock
        case discountedPrice = "discounted_price"
        case thumbnails
        case images
        case registrationDate = "registration_date"
    }
}

struct MarketItemForPost: Encodable {
    let title: String
    let descriptions: String
    let price: Int
    let currency: String
    let stock: Int
    let discountedPrice: Int?
    let images: [Data]
    let password: String
    
    enum CodingKeys: String, CodingKey {
        case title
        case descriptions
        case price
        case currency
        case stock
        case discountedPrice = "discounted_price"
        case images
        case password
    }
}

struct MarketItemForPatch: Encodable {
    let title: String?
    let descriptions: String?
    let price: Int?
    let currency: String?
    let stock: Int?
    let discountedPrice: Int?
    let images: [Data]?
    let password: String
    
    enum CodingKeys: String, CodingKey {
        case title
        case descriptions
        case price
        case currency
        case stock
        case discountedPrice = "discounted_price"
        case images
        case password
    }
}

struct MarketItemForDelete: Encodable {
    let id: Int
    let password: String
}
