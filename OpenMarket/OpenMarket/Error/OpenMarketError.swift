//
//  OpenMarketError.swift
//  OpenMarket
//
//  Created by 이영우 on 2021/05/14.
//

import Foundation

enum OpenMarketError: Error {
  case connectionProblem
  case invalidData
  case invalidRequest
  case invalidResponse
}
