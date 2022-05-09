//
//  Image.swift
//  OpenMarket
//
//  Created by 김태훈 on 2022/05/09.
//

import Foundation

struct Image: Codable {
    let id: Int
    let url: String
    let thumbnailUrl: String
    let succeed: Bool
    let issuedAt: String
    
    private enum CodingKeys: String, CodingKey {
        case thumbnailUrl = "thumbnail_url"
        case issuedAt = "issued_at"
        case id, url, succeed
    }
}
