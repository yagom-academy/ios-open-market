//
//  Item.swift
//  OpenMarket
//
//  Created by duckbok on 2021/05/12.
//

import UIKit

struct Item {
    let id: Int
    let title: String
    let descriptions: String
    let price: Int
    let currency: String
    let stock: Int
    let discountedPrice: Int?
    let thumbnails: [UIImage]
    let images: [UIImage]
    let registrationData: Date
}
