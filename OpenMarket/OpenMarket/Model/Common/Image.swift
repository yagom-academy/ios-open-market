//
//  Image.swift
//  OpenMarket
//
//  Created by 서녕 on 2022/01/09.
//

import Foundation

struct Image: Codable {
    let id: Int
    let url: String
    let thumbnailURL: String
    let succeed: Bool
    let issuedAt: String
    
    private enum CodingKeys: String, CodingKey {
        case id
        case url
        case thumbnailURL = "thumbnail_url"
        case succeed
        case issuedAt = "issued_at"
    }
}
