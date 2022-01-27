//
//  ImageData.swift
//  OpenMarket
//
//  Created by 권나영 on 2022/01/27.
//

import Foundation

struct ImageData: Decodable {
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
