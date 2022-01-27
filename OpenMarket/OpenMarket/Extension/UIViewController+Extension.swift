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
  case invalidPassword
  case productDeleteFailed
  case productDeleteSucceed(productName: String)
}

extension AlertMessage {
  var description: String {
    switch self {
    case .rangeOfImageCount:
      return "이미지는 최소 1개, 최대 5개까지 등록 가능합니다."
    case .imageLoadingFailed:
      return "이미지를 불러오지 못했습니다."
    case .invalidPassword:
      return "비밀번호가 일치하지 않습니다."
    case .productDeleteFailed:
      return "상품을 삭제하는데 실패했습니다.\n 다시 시도해주세요"
    case .productDeleteSucceed(let productName):
      return "상품 \(productName)를 삭제 하였습니다."
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
