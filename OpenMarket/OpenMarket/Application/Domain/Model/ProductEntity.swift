//
//  ProductEntity.swift
//  OpenMarket
//
//  Created by Derrick kim on 2022/07/19.
//

import UIKit

struct ProductEntity: Hashable {
    let id = UUID()
    let thumbnailImage: UIImage
    let name: String
    let currency: String
    let originalPrice: Int
    let discountedPrice: Int
    let stock: Int
}
