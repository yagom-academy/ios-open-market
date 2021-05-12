//
//  PostingItem.swift
//  OpenMarket
//
//  Created by Neph on 2021/05/12.
//
import Foundation

struct PostingItem: Encodable {
    let title: String
    let descriptions: String
    let price: Int
    let currency: String
    let stock: Int
    let discountedPrice: Int?
    let images: [Data]
    let password: String

    enum CodingKeys: String, CodingKey {
        case title, descriptions, price, stock, images, password
        case discountedPrice = "discounted_price"
    }

    var textFields: [String: String?] {
        let fields: [String: String?] = [
            "title": title,
            "descriptions": descriptions,
            "price": price.description,
            "currency": currency,
            "stock": stock.description,
            "discountedPrice": discountedPrice?.description,
            "password": password
        ]

        return fields
    }

    var fileFields: [Data] {
        var fields: [Data] = []
        fields.append(contentsOf: images)

        return fields
    }
}
