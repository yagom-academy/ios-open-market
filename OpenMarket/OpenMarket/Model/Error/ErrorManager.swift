//
//  ErrorManager.swift
//  OpenMarket
//  Created by inho, Hamo, Jeremy on 2022/11/25.
//

import UIKit

struct ErrorManager {
    func createAlert(error: Error) -> UIAlertController {
        let alert = UIAlertController(title: nil,
                                      message: error.localizedDescription,
                                      preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okButton)
        return alert
    }

    func showFailedImage() -> UIImage? {
        return UIImage(named: "noImage")
    }
}
