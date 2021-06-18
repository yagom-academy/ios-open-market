//
//  NSMutableData + Extension.swift
//  OpenMarket
//
//  Created by 황인우 on 2021/06/17.
//

import Foundation

extension NSMutableData {
  func appendString(_ string: String) {
    if let data = string.data(using: .utf8) {
      self.append(data)
    }
  }
}
