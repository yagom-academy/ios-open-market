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
    
    func presentActionSheet(actionTitle: String, cancelTitle: String, handler: ((UIAlertAction) -> ())?) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let updateAction = UIAlertAction(title: actionTitle, style: .default, handler: handler)
        let deleteAction = UIAlertAction(title: cancelTitle, style: .destructive, handler: handler)
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        alert.addAction(updateAction)
        alert.addAction(deleteAction)
        alert.addAction(cancel)
        
        self.present(alert, animated: true, completion: nil)
    }

}
