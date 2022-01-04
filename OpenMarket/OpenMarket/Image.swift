//
//  Image.swift
//  OpenMarket
//
//  Created by Ari on 2022/01/04.
//

import Foundation

struct Image: Codable {
    let id: Int
    let url: String
    let thumbnailURL: String
    let succeed: Bool
    let issuedAt: String

    enum CodingKeys: String, CodingKey {
        case id, url, succeed
        case thumbnailURL = "thumbnail_url"
        case issuedAt = "issued_at"
    }
}
