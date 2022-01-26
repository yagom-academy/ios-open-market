//
//  UIViewController+Extensions.swift
//  OpenMarket
//
//  Created by 권나영 on 2022/01/25.
//

import UIKit

extension UIViewController {
    func hideKeyboardOnTap() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func presentAlert(
        alertTitle: String,
        alertMessage: String,
        handler: ((UIAlertAction) -> ())?
    ) {
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        let ok = UIAlertAction(title: "확인", style: .default, handler: handler)
        alert.addAction(ok)
        
        self.present(alert, animated: true, completion: nil)
    }
}
