//
//  UIViewController+Extension.swift
//  OpenMarket
//
//  Created by parkhyo on 2022/12/03.
//

import UIKit

extension UIViewController {
    func showAlert(alertText: String, alertMessage: String, completion: (() -> (Void))?) {
        let alert = UIAlertController(title: alertText, message: alertMessage, preferredStyle: .alert)
        let confirm = UIAlertAction(title: "확인", style: .default) {  _ in
            if let completion = completion {
                completion()
            }
        }
        alert.addAction(confirm)
        self.present(alert, animated: true)
    }
}
