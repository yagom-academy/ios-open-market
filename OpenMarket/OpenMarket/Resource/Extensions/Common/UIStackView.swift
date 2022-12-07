//
//  UIStackView.swift
//  OpenMarket
//
//  Created by mini, baem on 2022/12/07.
//

import UIKit

extension UIStackView {
    convenience init(
        axis: NSLayoutConstraint.Axis,
        distribution: UIStackView.Distribution,
        spacing: CGFloat
    ) {
        self.init()
        self.axis = axis
        self.distribution = distribution
        self.spacing = spacing
    }
    
    func configureSubViews(subViews: [UIView]) {
        subViews.forEach {
            self.addArrangedSubview($0)
        }
    }
}
