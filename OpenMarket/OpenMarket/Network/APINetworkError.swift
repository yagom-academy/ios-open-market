//
//  APINetworkError.swift
//  OpenMarket
//  Created by Lingo, Quokka on 2022/05/11.
//

import Foundation

enum APINetworkError: LocalizedError {
  case badRequest
  
  var errorDescription: String? {
    switch self {
    case .badRequest:
      return "올바르지 않은 요청입니다."
    }
  }
}
