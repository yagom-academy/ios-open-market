//
//  MultipartTypeConverter.swift
//  OpenMarket
//
//  Created by 배은서 on 2021/05/25.
//

import Foundation

protocol MultipartTypeConverter {
    typealias MultipartType = [String: Any?]
    
    var multipart: MultipartType { get }
    var title: String? { get }
    var descriptions: String? { get }
    var currency: String? { get }
    var price: Int? { get }
    var discountedPrice: Int? { get }
    var stock: Int? { get }
    var imagesFiles: [Data]? { get }
    var password: String? { get }
}

extension MultipartTypeConverter {
    var multipart: MultipartType {
        return [
            "title": self.title,
            "descriptions": self.descriptions,
            "currency": self.currency,
            "price": self.price,
            "discountedPrice": self.discountedPrice,
            "stock": self.stock,
            "images[]": self.imagesFiles,
            "password": self.password
        ]
    }
}
