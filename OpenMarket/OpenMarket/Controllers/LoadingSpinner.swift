//
//  LoadingSpinner.swift
//  OpenMarket
//
//  Created by leewonseok on 2022/11/22.
//
import UIKit
class LoadingSpinner {
    static func showLoading() {
        DispatchQueue.main.async {
            guard let window = UIApplication.shared.windows.last else { return }

            let spinnerView: UIActivityIndicatorView
            if let firstView = window.subviews.first(where: { $0 is UIActivityIndicatorView } ) as? UIActivityIndicatorView {
                spinnerView = firstView
            } else {
                spinnerView = UIActivityIndicatorView(style: .large)
                spinnerView.backgroundColor = .systemGray
                spinnerView.frame = window.frame
                spinnerView.color = .darkGray
                window.addSubview(spinnerView)
            }

            spinnerView.startAnimating()
        }
    }

    static func hideLoading() {
        DispatchQueue.main.async {
            guard let window = UIApplication.shared.windows.last else { return }
            window.subviews.filter({ $0 is UIActivityIndicatorView }).forEach { $0.removeFromSuperview() }
        }
    }
}
