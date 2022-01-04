//
//  Vendor.swift
//  OpenMarket
//
//  Created by Eunsoo KIM on 2022/01/04.
//

import Foundation

struct Vendor: Codable {
  let id: Int
  let name: String
  let secret: String?
  let createdAt: String
  let issuedAt: String

  enum CodingKeys: String, CodingKey {
    case id, name, secret
    case createdAt = "created_at"
    case issuedAt = "issued_at"
  }
}
