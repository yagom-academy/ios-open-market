//
//  CALayer+Extension.swift
//  OpenMarket
//
//  Created by cathy, mmim.
//

import UIKit

extension CALayer {
  func addBottomBorder() {
    let border = CALayer()
    let borderWidth = 0.5
    border.frame = CGRect(x: 10, y: frame.height - borderWidth,
                          width: frame.width, height: borderWidth)
    border.backgroundColor = UIColor.systemGray.cgColor
    self.addSublayer(border)
  }
}
