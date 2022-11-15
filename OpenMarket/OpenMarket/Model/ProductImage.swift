//  ProductImage.swift
//  OpenMarket
//  Created by SummerCat & Bella on 2022/11/15.

import Foundation

struct ProductImage: Decodable {
    let id: Int
    let url: String
    let thumbnailUrl: String
    let issuedAt: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case url
        case thumbnailUrl = "thumbnail_url"
        case issuedAt = "issued_at"
    }
}
