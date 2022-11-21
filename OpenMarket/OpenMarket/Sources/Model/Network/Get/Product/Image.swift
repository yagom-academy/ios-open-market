//
//  OpenMarket - Image.swift
//  Created by Zhilly, Dragon. 22/11/15
//  Copyright © yagom. All rights reserved.
//

struct Image: Codable {
    let id: Int
    let url: String
    let thumbnailURL: String
    let issuedAt: String
   
    enum CodingKeys: String, CodingKey {
        case id
        case url
        case thumbnailURL = "thumbnail_url"
        case issuedAt = "issued_at"
    }
}
