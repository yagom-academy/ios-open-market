//
//  UIViewController+Extensions.swift
//  OpenMarket
//
//  Created by 전민수 on 2022/07/23.
//

import UIKit

extension UIViewController {
    func presentConfirmAlert(message: String) {
        let alertController = UIAlertController(title: AlertSetting.controller.title,
                                                message: message,
                                                preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: AlertSetting.confirmAction.title,
                                          style: .default) { [weak self] _ in
            if AlertMessage(rawValue: message) == .enrollmentSuccess {
                self?.dismiss(animated: true)
            }
        }
        
        alertController.addAction(confirmAction)
        self.present(alertController,
                     animated: false)
    }
}
