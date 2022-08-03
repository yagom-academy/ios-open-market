//
//  ProductDetailsEntity.swift
//  OpenMarket
//
//  Created by 데릭, 수꿍.
//

import UIKit

struct ProductDetailsEntity: Hashable {
    let id: Int
    let vendorID: Int
    let name: String
    let description: String
    let currency: Currency
    let price: Double
    let bargainPrice: Double
    let stock: Int
    let images: [UIImage]
}

