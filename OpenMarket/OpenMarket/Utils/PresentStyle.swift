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
}
