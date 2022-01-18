//
//  UIViewController+extension.swift
//  OpenMarket
//
//  Created by Ari on 2022/01/10.
//

import UIKit

extension UIViewController {
    func showAlert(message: String) {
        let okAction = UIAlertAction(title: "OK", style: .default)
        let alert = UIAlertController(title: "알림", message: message, preferredStyle: .alert)
        alert.addAction(okAction)
        self.present(alert, animated: true)
    }
}
