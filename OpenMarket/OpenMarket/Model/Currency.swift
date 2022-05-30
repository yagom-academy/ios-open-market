//
//  Currency.swift
//  OpenMarket
//
//  Created by cathy, mmim.
//

import Foundation

enum Currency: String, Codable {
  case won = "KRW"
  case dollar = "USD"
  
  var text: String {
    return self.rawValue
  }
  
  var optionNumber: Int {
    switch self {
    case .won:
      return 0
    case .dollar:
      return 1
    }
  }
}
