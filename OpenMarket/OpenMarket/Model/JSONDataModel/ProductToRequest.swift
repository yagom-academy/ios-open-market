//
//  ProductToRequest.swift
//  OpenMarket
//
//  Created by Ayaan, junho on 2022/12/08.
//

import Foundation

struct ProductToRequest {
    let id: Int?
    let name: String
    let description: String
    let currency: Currency
    let price: Double
    let discountedPrice: Double
    let stock: Int
    let thumbnailID: Int?
    let secret: Secret
    
    private enum CodingKeys: String, CodingKey {
        case name, description
        case currency
        case price
        case discountedPrice = "discounted_price"
        case stock
        case thumbnailID = "thumbnail_id"
        case secret
    }
    
    init?(id: Int? = nil, name: String?, description: String?, currency: Currency?, price: String?, discountedPrice: String?, stock: String?, thumbnailID: Int? = nil, secret: Secret) {
        guard let name: String = name,
              let priceText: String = price,
              let price: Double = Double(priceText),
              let description: String = description,
              let currency: Currency = currency else {
            return nil
        }

        let discountedPrice: Double = Double(discountedPrice ?? "") ?? 0
        let stock: Int = Int(stock ?? "") ?? 0

        self.id = id
        self.name = name
        self.description = description
        self.currency = currency
        self.price = price
        self.discountedPrice = discountedPrice
        self.stock = stock
        self.thumbnailID = thumbnailID
        self.secret = secret
    }
}

extension ProductToRequest: Encodable {
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.name, forKey: .name)
        try container.encode(self.description, forKey: .description)
        try container.encode(self.currency, forKey: .currency)
        try container.encode(self.price, forKey: .price)
        try container.encode(self.discountedPrice, forKey: .discountedPrice)
        try container.encode(self.stock, forKey: .stock)
        try container.encodeIfPresent(self.thumbnailID, forKey: .thumbnailID)
        try container.encode(self.secret.secretKey, forKey: .secret)
    }
}
