//
//  UIViewController+Extension.swift
//  OpenMarket
//
//  Created by 박병호 on 2022/01/17.
//

import UIKit

enum AlertMessage {
  case rangeOfImageCount
  case imageLoadingFailed
}

extension AlertMessage {
  var description: String {
    switch self {
    case .rangeOfImageCount:
      return "이미지는 최소 1개, 최대 5개까지 등록 가능합니다."
    case .imageLoadingFailed:
      return "이미지를 불러오지 못했습니다."
    }
  }
}

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
