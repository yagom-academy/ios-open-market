//
//  ItemModificationRequest.swift
//  OpenMarket
//
//  Created by Zero DotOne on 2021/01/28.
//

import Foundation

struct ItemModificationRequest {
    let title: String? = nil
    let descriptions: String? = nil
    let price: Int? = nil
    let currency: String? = nil
    let stock: Int? = nil
    let discountedPrice: Int? = nil
    let images: [Data]? = nil
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
