//
//  ProductEntity.swift
//  OpenMarket
//
//  Created by 데릭, 케이, 수꿍. 
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
