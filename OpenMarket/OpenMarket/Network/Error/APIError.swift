//
//  APIError.swift
//  OpenMarket
//
//  Created by 박병호 on 2022/01/24.
//

import Foundation

enum  APIError: Error {
  case getProductFailed
  case productRegistrationFailed
  case productModificationFailed
  case productDeleteFailed
}

extension APIError: LocalizedError {
  var errorDescription: String? {
    switch self {
    case .getProductFailed:
      return "데이터를 불러오지 못했습니다\n다시 시도해주세요"
    case .productRegistrationFailed:
      return "상품등록에 실패 했습니다\n다시 시도해 주세요"
    case .productModificationFailed:
      return "상품수정에 실패 했습니다\n다시 시도해 주세요"
    case .productDeleteFailed:
      return "상품삭제에 실패 했습니다\n다시 시도해 주세요"
    }
  }
}
