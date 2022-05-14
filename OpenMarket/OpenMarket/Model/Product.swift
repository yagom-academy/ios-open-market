//
//  Products.swift
//  OpenMarket
//
//  Created by marlang, Taeangel on 2022/05/10.
//
import Foundation

struct Product: Decodable {
    let id: Int?
    let vendorId: Int?
    let name: String?
    let thumbnail: String?
    let currency: String?
    let price: Int?
    let bargainPrice: Int?
    let discountedPrice: Int?
    let stock: Int?
    let createdAt: String?
    let issuedAt: String?
}
