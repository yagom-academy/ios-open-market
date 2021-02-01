//
//  UIViewControllerExtension.swift
//  OpenMarket
//
//  Created by Wonhee on 2021/02/01.
//

import UIKit

extension UIViewController {
    func showErrorAlert(with error
                            : Error, okHandler: ((UIAlertAction) -> Void)?) {
        var errorMessage: String
        if let openMarketError = error as? OpenMarketError {
            errorMessage = openMarketError.localizedDescription
        } else if let networkError = error as? NetworkError {
            errorMessage = networkError.localizedDescription
        } else {
            errorMessage = OpenMarketError.unknown.localizedDescription
        }
        let alertController = UIAlertController(title: "오류", message: errorMessage, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default, handler: okHandler)
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
