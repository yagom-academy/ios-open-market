//
//  ProductPresentable.swift
//  OpenMarket
//
//  Created by Jun Bang on 2022/01/27.
//

import Foundation

protocol ProductPresentable {
    var id: Int { get }
    var name: String { get }
    var currency: String { get }
    var price: Double { get }
    var bargainPrice: Double { get }
    var discountedPrice: Double { get }
    var stock: Int { get }
}
