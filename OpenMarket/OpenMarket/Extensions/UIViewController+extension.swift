//
//  UIViewController+extension.swift
//  OpenMarket
//
//  Created by Grumpy, OneTool on 2022/05/26.
//

import UIKit

private extension OpenMarketConstant {
    static let close = "닫기"
}

extension UIViewController {
    func showAlert(title: String) {
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: OpenMarketConstant.close, style: .default)
        alert.addAction(action)
        present(alert, animated: true)
    }
    
    func showAlert(title: String, handler: @escaping ((UIAlertAction) -> Void)) {
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: OpenMarketConstant.close, style: .default, handler: handler)
        alert.addAction(action)
        present(alert, animated: true)
    }
    
}
