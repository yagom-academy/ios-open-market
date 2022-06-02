//
//  UIViewController+extension.swift
//  OpenMarket
//
//  Created by Grumpy, OneTool on 2022/05/26.
//

import UIKit

private extension OpenMarketEnum {
    static let close = "닫기"
}

extension UIViewController {
    func showAlert(alertTitle: String) {
        let alert = UIAlertController(title: alertTitle, message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: OpenMarketEnum.close, style: .default)
        alert.addAction(action)
        present(alert, animated: true)
    }
    
    func showAlert(alertTitle: String, handler: @escaping ((UIAlertAction) -> Void)) {
        let alert = UIAlertController(title: alertTitle, message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: OpenMarketEnum.close, style: .default, handler: handler)
        alert.addAction(action)
        present(alert, animated: true)
    }
    
}
