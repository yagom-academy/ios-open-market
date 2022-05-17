//
//  UIStackView.swift
//  OpenMarket
//
//  Created by song on 2022/05/17.
//

import UIKit

extension UIStackView {
    func addArrangedsubViews(_ views: UIView...) {
        views.forEach { view in
            addArrangedSubview(view)
        }
    }
}
