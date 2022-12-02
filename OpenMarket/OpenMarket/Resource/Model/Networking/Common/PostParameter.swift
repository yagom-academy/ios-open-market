//
//  PostParameter.swift
//  OpenMarket
//
//  Copyright (c) 2022 Minii All rights reserved.
        

import Foundation

struct PostParameter: Encodable {
    let name: String
    let description: String
    let price: Double
    let currency: Currency
    let discounted_price: Double
    let stock: Int
    let secret: String
}

