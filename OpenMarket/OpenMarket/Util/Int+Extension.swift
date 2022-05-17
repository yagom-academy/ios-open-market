//
//  Int+Extension.swift
//  OpenMarket
//
//  Created by cathy, mmim.
//

import Foundation

extension Int {
  func convertCurrency() -> String {
      let numberFormatter = NumberFormatter()
      numberFormatter.numberStyle = .decimal
      
      guard let currencyNumber = numberFormatter.string(for: self) else {
          return ""
      }
      
      return currencyNumber
  }
}

