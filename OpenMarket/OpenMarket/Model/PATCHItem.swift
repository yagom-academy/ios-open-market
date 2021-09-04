//
//  PATCHItem.swift
//  OpenMarket
//
//  Created by 박태현 on 2021/08/31.
//

import Foundation

struct PATCHItem {
    private let title: String?
    private let descriptions: String?
    private let price: Int?
    private let currency: String?
    private let stock: Int?
    private let discountedPrice: Int?
    private let password: String

    init(title: String?, descriptions: String?, price: Int?, currency: String?, stock: Int?, discountedPrice: Int?, password: String) {
        self.title = title
        self.descriptions = descriptions
        self.price = price
        self.currency = currency
        self.stock = stock
        self.discountedPrice = discountedPrice
        self.password = password
    }

    func parameter() -> Parameters {
        var parameter: Parameters = ["password": self.password]
            if let title = self.title {
                parameter["title"] = title
            }
            if let descriptions = self.descriptions {
                parameter["descriptions"] = descriptions
            }
            if let price = self.price {
                parameter["price"] = price
            }
            if let currency = self.currency {
                parameter["currency"] = currency
            }
            if let stock = self.stock {
                parameter["stock"] = stock
            }
            if let discountedPrice = self.discountedPrice {
                parameter["discounted_price"] = discountedPrice
            }
            return parameter
    }
}
