//
//  ImageData.swift
//  OpenMarket
//  Created by inho, Hamo, Jeremy on 2022/11/15.
//

import Foundation

struct ImageData: Decodable, Hashable {
    let identifier: Int
    let url: String
    let thumbnailUrl: String
    let issuedDate: String
    
    enum CodingKeys: String, CodingKey {
        case identifier = "id"
        case url
        case thumbnailUrl
        case issuedDate = "issuedAt"
    }
}
