//
//  UIStackView.swift
//  OpenMarket
//
//  Created by mini, baem on 2022/12/07.
//

import UIKit

extension UIStackView {
    convenience init(
        subViews: [UIView],
        axis: NSLayoutConstraint.Axis,
        distribution: UIStackView.Distribution,
        spacing: CGFloat
    ) {
        self.init(arrangedSubviews: subViews)
        self.axis = axis
        self.distribution = distribution
        self.spacing = spacing
    }
}
