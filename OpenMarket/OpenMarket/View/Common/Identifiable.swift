//
//  Identifiable.swift
//  OpenMarket
//
//  Created by Lingo, Quokka on 2022/05/17.
//

protocol Identifiable {
  static var identifier: String { get }
}

extension Identifiable {
  static var identifier: String {
    return String(describing: self)
  }
}
