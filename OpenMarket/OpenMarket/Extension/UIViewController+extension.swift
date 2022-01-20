//
//  UIViewController+extension.swift
//  OpenMarket
//
//  Created by Ari on 2022/01/10.
//

import UIKit

extension UIViewController {
    func showAlert(message: String, completion: (() -> Void)? = nil) {
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            completion?()
        }
        let alert = UIAlertController(title: "알림", message: message, preferredStyle: .alert)
        alert.addAction(okAction)
        self.present(alert, animated: true)
    }
    
    func alertInputPassword(complection: @escaping (String) -> Void) {
        var resultTextField = UITextField()
        let alert = UIAlertController(title: "비밀번호를 입력해주세요", message: nil, preferredStyle: .alert)
        alert.addTextField { userTextField in
            resultTextField = userTextField
        }
        let okAcrion = UIAlertAction(title: "OK", style: .default) { _ in
            guard let secret = resultTextField.text else {
                DispatchQueue.main.async {
                    self.showAlert(message: Message.unknownError)
                }
                return
            }
            complection(secret)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(okAcrion)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
}
