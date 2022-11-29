//
//  Alerter.swift
//  OpenMarket
//
//  Created by 유제민 on 2022/11/25.
//

import UIKit

struct ErrorManager {
    func createAlert(title: String, message: String) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okButton)
        return alert
    }

    func switchError(error: NetworkError) -> UIAlertController {
        switch error {
        case .failedToParse:
            return createAlert(title: error.localizedDescription, message: "")
        case .missingData:
            return createAlert(title: error.localizedDescription, message: "섹시 하모")
        case .serverError:
            return createAlert(title: error.localizedDescription, message: "큐트 인호")
        case .transportError:
            return createAlert(title: error.localizedDescription, message: "쿠키 쿠키")
        }
    }

    func showFailedImage() -> UIImage? {
        return UIImage(named: "noImage")
    }
}
