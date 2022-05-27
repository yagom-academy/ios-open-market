//
//  AlertController.swift
//  OpenMarket
//
//  Created by 김동욱 on 2022/05/27.
//

import UIKit

extension UIAlertController {
    func addActions(_ action: UIAlertAction...) {
        action.forEach { action in
            addAction(action)
        }
    }
}
