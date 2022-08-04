//
//  UIViewController+Extensions.swift
//  OpenMarket
//
//  Created by 데릭, 수꿍.
//

import UIKit

extension UIViewController {
    func presentConfirmAlert(message: String) {
        let alertController = UIAlertController(title: AlertSetting.controller.title,
                                                message: message,
                                                preferredStyle: .alert)
        
        DispatchQueue.main.async {
            let confirmAction = UIAlertAction(title: AlertSetting.confirmAction.title,
                                              style: .default) { [weak self] _ in
                
                switch AlertMessage(rawValue: message) {
                case .enrollmentSuccess, .modificationSuccess:
                    self?.dismiss(animated: true)
                case .deleteSuccess:
                    self?.navigationController?.popViewController(animated: true)
                default:
                    break
                }
            }
            
            alertController.addAction(confirmAction)
            self.present(alertController,
                         animated: false)
        }
    }
    
    func present(viewController: UIViewController) {
        let rootViewController = UINavigationController(rootViewController: viewController)
        rootViewController.modalPresentationStyle = .fullScreen
        
        self.present(rootViewController, animated: true)
    }
}
