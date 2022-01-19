//
//  VendorInfo.swift
//  OpenMarket
//
//  Created by Eunsoo KIM on 2022/01/19.
//

import Foundation

struct VendorInfo: Codable {
  let name: String
  let id: Int
  let createdAt: String
  let issuedAt: String
  
  enum CodingKeys : String, CodingKey {
    case name, id
    case createdAt = "created_at"
    case issuedAt = "issued_at"
  }
  
}
