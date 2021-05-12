//
//  Product.swift
//  OpenMarket
//
//  Created by Fezz, Tak on 2021/05/12.
//

import Foundation

protocol MarketSecurity: Encodable {
    var password: String { get }
}

protocol ProductList: Decodable {
    associatedtype T
    var page: UInt { get }
    var items: [T] { get }
}

protocol ProductInfo: Decodable {
    var id: UInt { get }
    var title: String { get }
    var price: UInt { get }
    var currency: String { get }
    var stock: UInt { get }
    var discountedPrice: UInt? { get }
    var thumbnails: [String] { get }
    var registrationData: Double { get }
}

protocol ProductDetail: ProductInfo {
    var descriptions: String { get }
    var images: [String] { get }
}

protocol ProductReigistrate: MarketSecurity {
    var title: String { get }
    var descriptions: String { get }
    var price: UInt { get }
    var currency: String { get }
    var stock: UInt { get }
    var discountedPrice: UInt? { get }
    var images: [Data] { get }
}

protocol ProductEdit: MarketSecurity {
    var title: String? { get }
    var descriptions: String? { get }
    var price: UInt? { get }
    var currency: String? { get }
    var stock: UInt? { get }
    var discountedPrice: UInt? { get }
    var images: [Data]? { get }
}
