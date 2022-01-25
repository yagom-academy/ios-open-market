//
//  NumberFormatter.swift
//  OpenMarket
//
//  Created by 박병호 on 2022/01/13.
//

import Foundation

struct PresentStyle {
  static var numberFormatter: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal

    return formatter
  }()
  
  static func formatNumber(_ number: Double) -> String {
    return numberFormatter.string(for: number) ?? ""
  }
  
  static func formatNumber(_ number: Int) -> String {
    return numberFormatter.string(for: number) ?? ""
  }
  
  static func formatString(_ string: String) -> Double? {
    guard let number = numberFormatter.number(from: string) else {
      return 0
    }
    return Double(exactly: number)
  }
}
