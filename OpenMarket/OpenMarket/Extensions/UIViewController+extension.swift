//
//  UIViewController+extension.swift
//  OpenMarket
//
//  Created by Grumpy, OneTool on 2022/05/26.
//

import UIKit

extension UIViewController {
    func showAlert(alertTitle: String) {
        let alert = UIAlertController(title: alertTitle, message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "닫기", style: .default)
        alert.addAction(action)
        present(alert, animated: true)
    }
    
    func showAlert(alertTitle: String, handler: @escaping ((UIAlertAction) -> Void)) {
        let alert = UIAlertController(title: alertTitle, message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "닫기", style: .default, handler: handler)
        alert.addAction(action)
        present(alert, animated: true)
    }
    
}
