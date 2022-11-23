//  ProductImage.swift
//  OpenMarket
//  Created by SummerCat & Bella on 2022/11/15.

import Foundation

struct ProductImage: Decodable, Identifiable {
    let ID: Int
    let URL: String
    let thumbnailURL: String
    let issuedAt: String
    
    enum CodingKeys: String, CodingKey {
        case ID = "id"
        case URL = "url"
        case thumbnailURL = "thumbnail_url"
        case issuedAt = "issued_at"
    }
}
