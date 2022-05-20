//
//  UIActivityIndicator+extension.swift.swift
//  OpenMarket
//
//  Created by dudu, safari on 2022/05/18.
//

import UIKit

extension UIActivityIndicatorView {
    func stop() {
        if isAnimating {
            stopAnimating()
        }
    }
}
