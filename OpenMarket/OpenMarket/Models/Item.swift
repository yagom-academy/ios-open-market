//
//  Item.swift
//  OpenMarket
//
//  Created by 주디, 재재 on 2022/07/15.
//

import UIKit

struct Item: Hashable {
    let productImage: UIImage
    let productName: String
    let price: String
    var bargainPrice: String
    var stock: String
}
