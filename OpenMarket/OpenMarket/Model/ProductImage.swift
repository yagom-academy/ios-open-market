//
//  ProductImage.swift
//  OpenMarket
//
//  Created by JeongTaek Han on 2022/01/06.
//

import Foundation

struct ProductImage: Decodable {
    
    let id: Int
    let url: String
    let thumbnailURL: String
    let succeed: Bool
    let issuedAt: String

    enum CodingKeys: String, CodingKey {
        case id
        case url
        case thumbnailURL = "thumbnail_url"
        case succeed
        case issuedAt = "issued_at"
    }
    
}
