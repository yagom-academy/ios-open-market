//
//  UILabel+Extension.swift
//  OpenMarket
//
//  Created by Lingo, Quokka on 2022/05/17.
//

import UIKit

extension UILabel {
  func setStrike(text: String) {
    let attributedString = NSMutableAttributedString(string: text)
    attributedString.addAttribute(
      NSAttributedString.Key.strikethroughStyle,
      value: 1,
      range: NSRange(location: .zero, length: attributedString.length))
    self.attributedText = attributedString
  }
}
