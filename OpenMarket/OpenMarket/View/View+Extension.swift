//
//  view+extension.swift
//  OpenMarket
//
//  Created by 우롱차, Donnie on 2022/05/18.
//

import UIKit

extension UIView {
    static var identifier: String {
        return String(describing: self)
    }
}

extension UIStackView {
    func addLastBehind(view: UIView) {
        let lastViewCount = self.arrangedSubviews.count
        if lastViewCount <= 1 {
            self.insertArrangedSubview(view, at: 0)
        } else {
            self.insertArrangedSubview(view, at: lastViewCount - 1)
        }
    }
}
