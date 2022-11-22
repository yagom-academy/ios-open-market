//
//  Product.swift
//  OpenMarket
//  Created by inho, Hamo, Jeremy on 2022/11/15.
//

import Foundation

struct ProductData: Decodable, Hashable {
    let identifier: Int
    let vendorIdentifier: Int
    let name: String
    let thumbnail: String
    let currency: String
    let price: Double
    let bargainPrice: Double
    let discountedPrice: Double
    let stock: Int
    let createdDate: String
    let issuedDate: String
    let vendorName: String?
    let description: String?
    let images: [ImageData]?
    let vendors: VendorData?
    
    enum CodingKeys: String, CodingKey {
        case identifier = "id"
        case vendorIdentifier = "vendorId"
        case name
        case thumbnail
        case currency
        case price
        case bargainPrice
        case discountedPrice
        case stock
        case createdDate = "createdAt"
        case issuedDate = "issuedAt"
        case vendorName
        case description
        case images
        case vendors
    }
}
