//
//  PatchingItem.swift
//  OpenMarket
//
//  Created by Neph on 2021/05/12.
//

import Foundation

struct PatchingItem: Encodable {
    let title: String?
    let descriptions: String?
    let price: Int?
    let currency: String?
    let stock: Int?
    let discountedPrice: Int?
    let images: [Data]?
    let password: String

    enum CodingKeys: String, CodingKey {
        case title, descriptions, price, stock, images, password
        case discountedPrice = "discounted_price"
    }

    var textFields: [String: String] {
        var fields: [String: String] = [:]

        for (key, value) in Mirror(reflecting: self).children {
            guard let key = key,
                  !(value is Data || value is [Data]),
                  let realValue = value as Any?,
                  let text = realValue as? CustomStringConvertible else { continue }

            fields.updateValue(text.description, forKey: key)
        }

        return fields
    }

    var fileFields: [String: Data] {
        var fields: [String: Data] = [:]

        for (key, value) in Mirror(reflecting: self).children {
            guard let key = key,
                  value is Data || value is [Data] else { continue }

            if let value = value as? Data {
                fields.updateValue(value, forKey: key)
            } else if let value = value as? [Data] {
                value.forEach({ fields.updateValue($0, forKey: key) })
            }
        }

        return fields
    }
}
