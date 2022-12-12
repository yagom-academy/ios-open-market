//
//  CustomAlert.swift
//  OpenMarket
//
//  Created by 써니쿠키, 메네 on 7/12/2022.
//

import UIKit

final class CustomAlert {
    static func showAlert(message: String, target: UIViewController) {
        let alert = UIAlertController(title: "알림", message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "확인", style: .default)
        
        alert.addAction(ok)
        target.present(alert, animated: true)
    }
}
