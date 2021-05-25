//
//  DataExtension.swift
//  OpenMarket
//
//  Created by 이영우 on 2021/05/20.
//

import Foundation

extension Data {
  mutating func appendString(_ string: String) {
    if let data = string.data(using: .utf8) {
      append(data)
    }
  }
}
