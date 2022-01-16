//
//  String+Extension.swift
//  OpenMarket
//
//  Created by 박병호 on 2022/01/11.
//

import UIKit

extension String {
  func strikeThrough(strikeTarget: String) -> NSAttributedString {
    let attributeString = NSMutableAttributedString(string: self)
    attributeString.addAttribute(
      NSAttributedString.Key.strikethroughStyle,
      value: NSUnderlineStyle.single.rawValue,
      range: (self as NSString).range(of: strikeTarget)
    )
    attributeString.addAttribute(
      .foregroundColor,
      value: UIColor.red,
      range: (self as NSString).range(of: strikeTarget)
    )
    
    return attributeString
  }
}
