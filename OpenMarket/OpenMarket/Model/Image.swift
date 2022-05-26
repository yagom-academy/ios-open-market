//
//  Image.swift
//  OpenMarket
//
//  Created by papri, Tiana on 26/05/2022.
//

import Foundation

struct Image: Decodable, Hashable {
    let identifier: Int
    let url: String
    let thumbnailURL: String
    
    enum CodingKeys: String, CodingKey {
        case identifier = "id"
        case url
        case thumbnailURL = "thumbnail_url"
    }
}
