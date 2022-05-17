//
//  UIStackView+Extension.swift
//  OpenMarket
//
//  Created by cathy, mmim.
//

import UIKit

extension UIStackView {
  func addArrangedSubviews(_ view: UIView...) {
    view.forEach { view in
      self.addArrangedSubview(view)
    }
  }
}
