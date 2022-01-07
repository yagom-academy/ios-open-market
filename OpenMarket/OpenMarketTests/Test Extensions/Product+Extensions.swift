//
//  Product+Extensions.swift
//  OpenMarketTests
//
//  Created by Jun Bang on 2022/01/07.
//

import Foundation
@testable import OpenMarket

extension Product: Equatable {
    public static func == (lhs: Product, rhs: Product) -> Bool {
        return lhs.id == rhs.id &&
            lhs.vendorID == rhs.vendorID &&
            lhs.name == rhs.name &&
            lhs.currency == rhs.currency &&
            lhs.price == rhs.price &&
            lhs.bargainPrice == rhs.bargainPrice &&
            lhs.discountedPrice == rhs.discountedPrice &&
            lhs.stock == rhs.stock &&
            lhs.createdAt == rhs.createdAt &&
            lhs.issuedAt == rhs.issuedAt
    }
}
