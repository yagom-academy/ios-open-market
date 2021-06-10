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
    var thumbnailsURL: [String] { get }
    var registrationDate: Double { get }
}

protocol ProductDetail: ProductInfo {
    var images: [String] { get }
    var descriptions: String { get }
}

protocol ProductRegistration: Encodable, Deletable {
    var title: String { get }
    var descriptions: String { get }
    var price: UInt { get }
    var currency: String { get }
    var stock: UInt { get }
    var discountedPrice: UInt? { get }
    var images: [Data] { get }
}

protocol ProductModify: Encodable, Deletable {
    var title: String? { get }
    var descriptions: String? { get }
    var price: UInt? { get }
    var currency: String? { get }
    var stock: UInt? { get }
    var discountedPrice: UInt? { get }
    var images: [Data]? { get }
}
