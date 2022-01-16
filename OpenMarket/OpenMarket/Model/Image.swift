//
//  Image.swift
//  OpenMarket
//
//  Created by Eunsoo KIM on 2022/01/04.
//

import Foundation

/**
 상품 이미지 정보의 모델타입입니다.
*/
struct Image: Codable {
  /// 상품 이미지 식별번호
  let id: Int
  /// 상품 이미지 url
  let url: String
  /// 상품 이미지 thumbnail url
  let thumbnailURL: String
  /// 이미지 리사이징 및 업로드 성공 여부
  let succeed: Bool
  /// 등록/수정일
  let issuedAt: String

  enum CodingKeys: String, CodingKey {
    case id, url, succeed
    case thumbnailURL = "thumbnail_url"
    case issuedAt = "issued_at"
  }
}

extension Image: Hashable { }
