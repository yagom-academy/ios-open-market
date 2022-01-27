//
//  InputError.swift
//  OpenMarket
//
//  Created by 박병호 on 2022/01/21.
//

import Foundation

enum InputError: Error {
  case invalidName
  case invalidDescription
  case invalidFixedPrice
  case invalidOthers
}

extension InputError: LocalizedError {
  var errorDescription: String? {
    switch self {
    case .invalidName:
      return "상품명을 3글자 이상 입력해주세요"
    case .invalidDescription:
      return "상세설명을 입력해 주세요"
    case .invalidFixedPrice:
      return "상품가격을 입력해주세요"
    case .invalidOthers:
      return "일시적인 오류가 발생했습니다\n다시 시도해 주세요"
    }
  }
}
