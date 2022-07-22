//
//  loadingView.swift
//  OpenMarket
//
//  Created by 주디, 재재 on 2022/07/20.
//

import UIKit

final class LoadingIndicator {
    static func showLoading(on view: UIView) {
        DispatchQueue.main.async {
            let loadingIndicatorView: UIActivityIndicatorView
            loadingIndicatorView = UIActivityIndicatorView(style: .large)
            loadingIndicatorView.frame = view.frame
            loadingIndicatorView.color = .systemGray
            view.addSubview(loadingIndicatorView)
            loadingIndicatorView.startAnimating()
        }
    }

    static func hideLoading(on view: UIView) {
        DispatchQueue.main.async {
            view.subviews.filter({ $0 is UIActivityIndicatorView }).forEach { $0.removeFromSuperview() }
        }
    }
}
