//
//  Data+Extension.swift
//  OpenMarket
//
//  Created by Lingo, Quokka on 2022/05/26.
//

import Foundation

extension Data {
  mutating func appendString(_ stringValue: String) {
    if let data = stringValue.data(using: .utf8) {
      self.append(data)
    }
  }
}
