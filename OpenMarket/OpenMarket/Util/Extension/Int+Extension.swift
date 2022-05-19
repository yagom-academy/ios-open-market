//
//  Int+Extension.swift
//  OpenMarket
//
//  Created by Lingo, Quokka on 2022/05/17.
//

import Foundation

extension Int {
  var toDecimal: String {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    return formatter.string(for: self) ?? ""
  }
}
