//
//  ItemRegistrationRequest.swift
//  OpenMarket
//
//  Created by Zero DotOne on 2021/01/27.
//

import Foundation

struct ItemRegistrationRequest {
    let title: String
    let descriptions: String
    let price: Int
    let currency: String
    let stock: Int
    let discountedPrice: Int?
    let images: [Data]
    let password: String
    
    var description: [String: Any] {[
        "title": title,
        "descriptions": descriptions,
        "price": price,
        "currency": currency,
        "stock": stock,
        "discountedPrice": discountedPrice,
        "images": images,
        "password": password
    ]}
}
