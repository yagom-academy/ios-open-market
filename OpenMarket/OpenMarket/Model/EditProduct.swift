//
//  EditProduct.swift
//  OpenMarket
//
//  Created by Gundy, Wonbi on 2022/12/01.
//

import Foundation

struct EditProduct {
    let productID: Int
    let secret: String
    let stock: String?
    let thumbnailID: String?
    let name, description: String?
    let discountedPrice, price: String?
    let currency: String?

    enum SnakeCase: String {
        case stock
        case product_id = "productID"
        case thumbnail_id = "thumbnailID"
        case name, description
        case discounted_price = "discountedPrice"
        case price, currency, secret
    }

    init(productID: Int,
         secret: String,
         stock: String? = nil,
         name: String? = nil,
         description: String? = nil,
         thumbnailID: String? = nil,
         discountedPrice: String? = nil,
         price: String? = nil,
         currency: Currency? = nil
    ) {
        self.productID = productID
        self.secret = secret
        self.stock = stock
        self.name = name
        self.description = description
        self.thumbnailID = thumbnailID
        self.discountedPrice = discountedPrice
        self.price = price
        self.currency = currency?.rawValue
    }
    
    func makeParams() -> Data {
        var params = "\"product_id\": \(productID), "
        
        let mirror = Mirror(reflecting: self)
        mirror.children.forEach { children in
            guard let label = children.label,
                  let key = SnakeCase(rawValue: label),
                  let value = children.value as? String else { return }
            if ["name", "description", "currency", "secret"].contains(key.rawValue) {
                params += "\"\(key)\": \"\(value)\", "
                return
            }
            params += "\"\(key)\": \(value), "
        }
        params.removeLast(2)
        
        return ("{" + params + "}").data(using: .utf8) ?? Data()
    }
}
