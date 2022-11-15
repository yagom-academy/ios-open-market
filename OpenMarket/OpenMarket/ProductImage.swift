//
//  ProductImage.swift
//  OpenMarket
//
//  Created by Ayaan, junho on 2022/11/15.
//

struct ProductImage: Decodable {
    let id: Int
    let url, thumbnailUrl, issuedAt: String
    
    enum CodingKeys: String, CodingKey {
        case id, url
        case thumbnailUrl = "thumbnail_url"
        case issuedAt = "issued_at"
    }
}
