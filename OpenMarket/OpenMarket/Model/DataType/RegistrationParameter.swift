//
//  RegistrationParameter.swift
//  OpenMarket
//
//  Created by 우롱차, Donnie on 2022/05/10.
//

import Foundation

struct RegistrationParameter: Codable {
    let name: String?
    let descriptions: String?
    private(set) var price: Double?
    let currency: Currency?
    private(set) var discountedPrice: Double?
    private(set) var stock: Int?
    let secret: String?
    
    private enum CodingKeys: String, CodingKey {
        case name
        case descriptions
        case price
        case currency
        case discountedPrice = "discounted_price"
        case stock
        case secret
    }
    
    mutating func changeValue(price: Double) {
        self.price = price
    }
    mutating func changeValue(discountedPrice: Double) {
        self.discountedPrice = discountedPrice
    }
    mutating func changeValue(stock: Int) {
        self.stock = stock
    }
}
