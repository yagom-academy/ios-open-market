//
//  loadingView.swift
//  OpenMarket
//
//  Created by 주디, 재재 on 2022/07/20.
//

import UIKit

final class LoadingIndicator {
    static func showLoading(superView: UIView) {
        DispatchQueue.main.async {
            let loadingIndicatorView: UIActivityIndicatorView
            loadingIndicatorView = UIActivityIndicatorView(style: .large)
            loadingIndicatorView.frame = superView.frame
            loadingIndicatorView.color = .systemGray
            superView.addSubview(loadingIndicatorView)
            loadingIndicatorView.startAnimating()
        }
    }

    static func hideLoading(superView: UIView) {
        DispatchQueue.main.async {
            superView.subviews.filter({ $0 is UIActivityIndicatorView }).forEach { $0.removeFromSuperview() }
        }
    }
}
