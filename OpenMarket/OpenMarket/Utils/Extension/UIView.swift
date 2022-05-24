//
//  UIView.swift
//  OpenMarket
//
//  Created by song on 2022/05/17.
//

import UIKit

extension UIView {
    func addsubViews(_ views: UIView...) {
        views.forEach { view in
            addSubview(view)
        }
    }
}
