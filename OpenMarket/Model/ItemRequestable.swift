//
//  ItemRequestable.swift
//  OpenMarket
//
//  Created by kjs on 2021/08/18.
//

import Foundation

struct ItemRequestable: Loopable {
    var title: String?
    var descriptions: String?
    var price: Int?
    var currency: String?
    var stock: Int?
    var discountedPrice: Int?
    var password: String
}
