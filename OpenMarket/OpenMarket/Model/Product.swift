//
//  Items.swift
//  OpenMarket
//
//  Created by Tak on 2021/05/31.
//

import Foundation

protocol Deletable {
    var password: String { get }
}

protocol ProductList: Decodable {
    var page: Int { get }
    var items: [String] { get }
}

protocol ProductInfo: Decodable {
    var id: Int { get }
    var title: String { get }
    var price: Int { get }
    var currency: String { get }
    var stock: Int { get }
    var discountedPrice: Int { get }
    var thumbnails: [String] { get }
    var registrationDate: Int { get }
}

protocol ProductDetail: ProductInfo {
    var images: [String] { get }
    var registrationDate: Int { get }
}

protocol ProductRegistration: Encodable, Deletable {
    var title: String { get }
    var descriptions: String { get }
    var price: Int { get }
    var currency: String { get }
    var stock: Int { get }
    var discountedPrice: Int? { get }
    var images: [Data] { get }
}

protocol ProductModify: Encodable, Deletable {
    var title: String? { get }
    var descriptions: String? { get }
    var price: Int? { get }
    var currency: String? { get }
    var stock: Int? { get }
    var discountedPrice: Int? { get }
    var images: [Data]? { get }
}
