//
//  Vendor.swift
//  OpenMarket
//
//  Created by Eunsoo KIM on 2022/01/04.
//

import Foundation

/**
 판매자의 정보의 모델타입입니다.
*/
struct Vendor: Codable {
  /// 판매자의 ID
  let id: Int
  /// 판매자의 이름
  let name: String
  /// 판매자의 패스워드
  let password: String?
  let createdAt: String
  let issuedAt: String

  enum CodingKeys: String, CodingKey {
    case id, name
    case password = "secret"
    case createdAt = "created_at"
    case issuedAt = "issued_at"
  }
}
