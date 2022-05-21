//
//  UIStackView+.swift
//  OpenMarket
//
//  Created by Eddy, marisol on 2022/05/20.
//
import UIKit

extension UIStackView {
    func addArrangedSubview(_ views: [UIView]) {
        for view in views {
            self.addArrangedSubview(view)
        }
    }
}
