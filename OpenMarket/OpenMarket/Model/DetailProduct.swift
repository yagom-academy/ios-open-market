//
//  Product.swift
//  OpenMarket
//
//  Created by marlang, Taeangel on 2022/05/10.
//
import Foundation

struct DetailProduct: Decodable {
    let id: Int?
    let vendorId: Int?
    let name: String?
    let thumbnail: String?
    let currency: String?
    let price: Int?
    let description: String?
    let bargainPrice: Int?
    let discountedPrice: Int?
    let stock: Int?
    let createdAt: String?
    let issuedAt: String?
    let images: [Images]?
}

struct Images: Codable {
    let id: Int?
    let url: String?
    let thumbnailUrl: String?
    let succeed: Bool?
    let issuedAt: String?
}
