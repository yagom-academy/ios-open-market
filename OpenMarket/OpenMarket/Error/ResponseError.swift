//
//  ResponseError.swift
//  OpenMarket
//
//  Created by 박병호 on 2022/01/07.
//

import Foundation

enum ResponseError: Error {
  case responseFailed
  case foundURLFailed
  case decodeFailed
  case encodeFailed
  
  var errorDescription: String {
    return "데이터를 불러오지 못했습니다.\n다시 시도해주세요."
  }
}
