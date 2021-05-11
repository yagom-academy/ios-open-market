//
//  ItemRegistrationForm.swift
//  OpenMarket
//
//  Created by steven on 2021/05/11.
//

import Foundation

struct ItemRegistrationForm: Codable {
    let title: String
    let descriptions: String
    let price: Int
    let currency: String
    let stock: Int
    let discounted_price: Int
    let images: [String]
    let password: String
}
