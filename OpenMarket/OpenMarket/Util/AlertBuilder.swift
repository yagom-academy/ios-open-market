//
//  AlertBuilder.swift
//  OpenMarket
//
//  Created by 조민호 on 2022/05/17.
//

import UIKit

struct AlertProduct {
    var title: String?
    var confirmTitle: String?
    var message: String?
    var confirmHandler: (() -> Void)?
}

protocol AlertBuilderable {
    init(viewController: UIViewController)
    func setTitle(_ title: String) -> AlertBuilderable
    func setConfirmTitle(_ confirmTitle: String) -> AlertBuilderable
    func setMessage(_ message: String) -> AlertBuilderable
    func setConfirmHandler(_ confirmHandler: @escaping (() -> Void)) -> AlertBuilderable
    func showAlert()
}

final class AlertBuilder: AlertBuilderable {
    private weak var viewController: UIViewController?
    private var product = AlertProduct()
    
    init(viewController: UIViewController) {
        self.viewController = viewController
    }
    
    func setTitle(_ title: String) -> AlertBuilderable {
        product.title = title
        return self
    }
    
    func setConfirmTitle(_ confirmTitle: String) -> AlertBuilderable {
        product.confirmTitle = confirmTitle
        return self
    }
    
    func setMessage(_ message: String) -> AlertBuilderable {
        product.message = message
        return self
    }
    
    func setConfirmHandler(_ confirmHandler: @escaping (() -> Void)) -> AlertBuilderable {
        product.confirmHandler = confirmHandler
        return self
    }
    
    func showAlert() {
        let alert = UIAlertController(title: product.title, message: product.message, preferredStyle: .alert)

        let confirmButton = UIAlertAction(title: product.confirmTitle, style: .default, handler: { _ in
            self.product.confirmHandler?()
        })
        
        alert.addAction(confirmButton)
        
        viewController?.present(alert, animated: true, completion: nil)
    }
}
