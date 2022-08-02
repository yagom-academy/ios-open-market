//
//  ModifiedProductEntity.swift
//  OpenMarket
//
//  Created by 데릭, 수꿍.
//

import Foundation

struct ModifiedProductEntity {
    let name: String?
    let descriptions: String?
    let thumbnail_id: Int?
    let price: Int?
    let currency: Currency?
    let discounted_price: Int?
    let stock: Int?
    let secret: String

    init(name: String? = nil,
         descriptions: String? = nil,
         thumbnail_id: Int? = nil,
         price: Int? = nil,
         currency: Currency? = nil,
         discounted_price: Int? = nil,
         stock: Int? = nil,
         secret: String) {

        self.name = name
        self.descriptions = descriptions
        self.thumbnail_id = thumbnail_id
        self.price = price
        self.currency = currency
        self.discounted_price = discounted_price
        self.stock = stock
        self.secret = secret
    }

    func returnValue() -> Data? {
        var dicValue = [String : String]()

        if let name = name {
            dicValue["name"] = "\(name)"
        }

        if let descriptions = descriptions {
            dicValue["descriptions"] = "\(descriptions)"
        }

        if let thumbnail_id = thumbnail_id {
            dicValue["thumbnail_id"] = "\(thumbnail_id)"
        }

        if let price = price {
            dicValue["price"] = "\(price)"
        }

        if let currency = currency {
            dicValue["currency"] = "\(currency.rawValue)"
        }

        if let discounted_price = discounted_price {
            dicValue["discounted_price"] = "\(discounted_price)"
        }

        if let stock = stock {
            dicValue["stock"] = "\(stock)"
        }

        dicValue["secret"] = "\(secret)"

        do {
            let data = try JSONSerialization.data(withJSONObject: dicValue,
                                                  options: [])
            return data
        } catch {
            return nil
        }
    }
}
