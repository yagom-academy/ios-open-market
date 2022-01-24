//
//  ReuseIdentifying.swift
//  OpenMarket
//
//  Created by 박병호 on 2022/01/17.
//

import Foundation

protocol ReuseIdentifying {
  static var reuseIdentifier: String { get }
  static var nibName: String { get }
  static var stroyBoardName: String { get }
}

extension ReuseIdentifying {
  static var reuseIdentifier: String {
    return String(describing: self)
  }
  
  static var nibName: String {
    return String(describing: self)
  }
  
  static var stroyBoardName: String {
    let ViewControllerName = String(describing: self)
    let storyBoardName = ViewControllerName.replacingOccurrences(of: "ViewController", with: "")
    return storyBoardName
  }
}
