//
//  PostingItem.swift
//  OpenMarket
//
//  Created by Neph on 2021/05/12.
//
import Foundation

struct PostingItem: Encodable {
    let title: String
    let description: String
    let price: Int
    let currency: String
    let stock: Int
    let discountedPrice: Int?
    let images: [Data]
    let password: String
    enum CodingKeys: String, CodingKey {
        case title, description, price, stock, images, password
        case discountedPrice = "discounted_price"
    }
    var textFields: [String: String?] {
        return ["":""]
    }
    var fileFields: [Data] {
        return [Data()]
    }
}
