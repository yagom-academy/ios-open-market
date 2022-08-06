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
        
        let confirmAction = UIAlertAction(title: AlertSetting.confirmAction.title,
                                          style: .default) { [weak self] _ in
            
            switch AlertMessage(rawValue: message) {
            case .enrollmentSuccess, .modificationSuccess:
                DispatchQueue.main.async {
                    self?.dismiss(animated: true)
                }
            case .deleteSuccess:
                DispatchQueue.main.async {
                    self?.navigationController?.popViewController(animated: true)
                }
            default:
                break
            }
        }
        
        alertController.addAction(confirmAction)
        
        present(alertController,
                animated: false)
    }
    
    func present(viewController: UIViewController) {
        let rootViewController = UINavigationController(rootViewController: viewController)
        rootViewController.modalPresentationStyle = .fullScreen
        
        present(rootViewController, animated: true)
    }
}


