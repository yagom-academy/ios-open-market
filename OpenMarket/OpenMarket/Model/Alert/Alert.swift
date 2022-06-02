//
//  Alert.swift
//  OpenMarket
//
//  Created by papri, Tiana on 26/05/2022.
//

import UIKit

struct Alert {
    func showWarning(title: String = "경고창", message: String? = nil, completionHandler: (() -> Void)? = nil) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let button = UIAlertAction(title: "ok", style: .default) { _ in
            completionHandler?()
        }
        alertController.addAction(button)
        return alertController
    }
}
