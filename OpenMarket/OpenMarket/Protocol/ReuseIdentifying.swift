//
//  ReuseIdentifying.swift
//  OpenMarket
//
//  Created by 박병호 on 2022/01/17.
//

import Foundation

protocol ReuseIdentifying {
    static var reuseIdentifier: String { get }
}

extension ReuseIdentifying {
  static var reuseIdentifier: String {
    return String(describing: Self.self)
  }
  
  static var nibName: String {
    return String(describing: self)
  }
}
