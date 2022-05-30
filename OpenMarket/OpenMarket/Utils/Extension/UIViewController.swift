//
//  UIViewController.swift
//  OpenMarket
//
//  Created by 김동욱 on 2022/05/30.
//

import UIKit

extension UIViewController {
    func showAlert(title: String?,
                   message: String? = nil,
                   ok: String? = "OK",
                   cancel: String? = nil,
                   action: (() -> Void)? = nil
    ) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        if let action = action {
            let yesAction = UIAlertAction(title: ok, style: .default) { _ in
                action()
                self.dismiss(animated: true)
            }
            alert.addAction(yesAction)
        } else {
            let yesAction = UIAlertAction(title: ok, style: .default)
            alert.addAction(yesAction)
            self.dismiss(animated: true)
        }
        
        if let cancel = cancel {
            let cancelAction = UIAlertAction(title: cancel, style: .destructive)
            alert.addAction(cancelAction)
        }
        
        present(alert, animated: true)
    }
}
