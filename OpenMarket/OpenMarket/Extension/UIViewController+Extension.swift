//
//  UIViewController+Extension.swift
//  OpenMarket
//
//  Created by 박병호 on 2022/01/17.
//

import UIKit

extension UIViewController {
  func showAlert(message: String) {
    let okAction = UIAlertAction(title: "OK", style: .default)
    let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
    alert.addAction(okAction)
    self.present(alert, animated: true)
  }
  
  func showAlert(message: AlertMessage) {
    let okAction = UIAlertAction(title: "OK", style: .default)
    let alert = UIAlertController(title: nil, message: message.description, preferredStyle: .alert)
    alert.addAction(okAction)
    self.present(alert, animated: true)
  }
}
