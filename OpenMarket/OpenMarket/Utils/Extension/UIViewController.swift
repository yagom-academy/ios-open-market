//
//  UIViewController.swift
//  OpenMarket
//
//  Created by 김동욱 on 2022/05/30.
//

import UIKit

fileprivate enum Const {
    static let ok = "OK"
}

extension UIViewController {
    
    func showAlert(
        title: String?,
        message: String? = nil,
        ok: String? = Const.ok,
        cancel: String? = nil,
        action: (() -> Void)? = nil
    ) {
        DispatchQueue.main.async { [weak self] in
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            
            if let cancel = cancel {
                let cancelAction = UIAlertAction(title: cancel, style: .destructive)
                alert.addAction(cancelAction)
            }
            
            if let action = action {
                let yesAction = UIAlertAction(title: ok, style: .default) { _ in
                    action()
                }
                alert.addAction(yesAction)
            } else {
                let yesAction = UIAlertAction(title: ok, style: .default)
                alert.addAction(yesAction)
            }
            
            self?.present(alert, animated: true)
        }
    }
}
