//
//  String+Extension.swift
//  OpenMarket
//
//  Created by cathy, mmim.
//

import UIKit

extension String {
  var integer: Int? {
    if let number = Int(self) {
      return number
    } else {
      return nil
    }
  }
  
  func strikeThrough() -> NSAttributedString {
    let attributeString: NSMutableAttributedString = NSMutableAttributedString(string: self)
    attributeString.addAttribute(
      NSAttributedString.Key.strikethroughStyle,
      value: NSUnderlineStyle.single.rawValue,
      range: NSMakeRange(0, attributeString.length)
    )
    return attributeString
  }
}
