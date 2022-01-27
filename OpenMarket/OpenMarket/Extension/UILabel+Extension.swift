//
//  UILabel+Extension.swift
//  OpenMarket
//
//  Created by 박병호 on 2022/01/24.
//

import UIKit

extension UILabel {
  func changeColor(targetString: String, color: UIColor?) {
    let fullText = text ?? ""
    let range = (fullText as NSString).range(of: targetString)
    let attributedString = NSMutableAttributedString(string: fullText)
    attributedString.addAttribute(.foregroundColor, value: color as Any, range: range)
    attributedText = attributedString
  }
}
