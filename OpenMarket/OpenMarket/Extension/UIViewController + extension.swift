//
//  UIViewController + extension.swift
//  OpenMarket
//
//  Created by unchain, hyeon2 on 2022/08/04.
//

import UIKit

extension UIViewController {
    func showCustomAlert(title: String?, message: String) {
        let okTitle = "확인"
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okButton = UIAlertAction(title: okTitle, style: .default)
        alertController.addAction(okButton)
        
        present(alertController, animated: true)
    }
}
