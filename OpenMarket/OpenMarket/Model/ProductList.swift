//
//  ProductList.swift
//  OpenMarket
//
//  Created by Eunsoo KIM on 2022/01/04.
//

import Foundation

/**
 상품 리스트의 모델타입입니다.
*/
struct ProductList: Codable {
  /// 현제 페이지 번호
  let pageNumber: Int
  /// 한 페이지당 row 갯수
  let itemsPerPage: Int
  /// 총 row 수
  let totalCount: Int
  /// 첫번째 index
  let offset: Int
  /// 마지막 index
  let limit: Int
  /// 상품 정보의 배열
  let pages: [Product]
  /// 마지막 페이지
  let lastPage: Int
  /// 다음 페이지 존재여부
  let hasNext: Bool
  /// 이전 페이지 존재여부
  let hasPrevious: Bool
  
  enum CodingKeys: String, CodingKey {
    case offset, limit, pages
    case pageNumber = "page_no"
    case itemsPerPage = "items_per_page"
    case totalCount = "total_count"
    case lastPage = "last_page"
    case hasNext = "has_next"
    case hasPrevious = "has_prev"
  }
}

extension ProductList: Hashable { }
