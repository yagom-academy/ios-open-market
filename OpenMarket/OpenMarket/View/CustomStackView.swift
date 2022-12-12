//
//  CustomStackView.swift
//  OpenMarket
//
//  Created by 써니쿠키, 메네 on 2/12/2022.
//

import UIKit

final class CustomStackView: UIStackView {
    init(axis: NSLayoutConstraint.Axis = .horizontal,
         distribution: Distribution = .fill,
         alignment: Alignment = .fill,
         spacing: CGFloat = 0) {
        super.init(frame: .zero)
        self.distribution = distribution
        self.axis = axis
        self.spacing = spacing
        self.alignment = alignment
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
