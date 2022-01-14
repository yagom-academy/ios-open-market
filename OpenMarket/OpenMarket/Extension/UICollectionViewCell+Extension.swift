//
//  UICollectionViewCell+Extension.swift
//  OpenMarket
//
//  Created by 박병호 on 2022/01/14.
//

import UIKit

extension UICollectionViewCell {
  static var reuseIdentifier: String {
    return String(describing: self)
  }
  
  static var nibName: String {
    return String(describing: self)
  }
}
