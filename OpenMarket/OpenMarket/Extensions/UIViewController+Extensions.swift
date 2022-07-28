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
                                          style: .default,
                                          handler: nil)
        
        alertController.addAction(confirmAction)
        self.present(alertController,
                     animated: false)
    }
    
    func present(to nextViewController: UIViewController) {
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
}
