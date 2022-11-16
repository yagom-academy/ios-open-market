//
//  image.swift
//  OpenMarket
//
//  Created by Jpush, Aaron on 2022/11/15.
//

import Foundation

struct Image: Codable {
    let id: Int
    let url: String
    let thumbnailUrl: String
    let issuedAt: Date
    
    enum CodingKeys: String, CodingKey {
        case id
        case url
        case thumbnailUrl = "thumbnail_url"
        case issuedAt = "issued_at"
    }
}
