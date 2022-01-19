//
//  itemImage.swift
//  OpenMarket
//
//  Created by Eunsoo KIM on 2022/01/19.
//

import Foundation

struct ItemImage: Codable {
  let itemId: Int
  let imageURL: String
  let thumbnailURL: String
  let isProperUpload: Bool
  let issuedAt: String
  
  enum CodingKeys : String, CodingKey {
    case itemId = "id"
    case imageURL = "url"
    case thumbnailURL = "thumbnail_url"
    case isProperUpload = "succeed"
    case issuedAt = "issued_at"
  }
}
