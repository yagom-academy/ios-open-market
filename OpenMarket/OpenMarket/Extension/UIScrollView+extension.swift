//
//  UIScrollView+extension.swift
//  OpenMarket
//
//  Created by 이호영 on 2022/01/11.
//

import UIKit

extension UIScrollView {
    func scrollToTop() {
        let topOffset = CGPoint(x: 0, y: -contentInset.top)
        setContentOffset(topOffset, animated: false)
    }
}
