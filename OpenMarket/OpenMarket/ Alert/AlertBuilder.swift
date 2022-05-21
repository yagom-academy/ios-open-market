//
//  AlertBuilder.swift
//  OpenMarket
//
//  Created by dudu, safari on 2022/05/20.
//

import UIKit

protocol AlertBuilderable {
    var alert: Alert { get }
    var alertOkAction: AlertAction { get }
    var alertCancelAction: AlertAction { get }
    var targetViewController: UIViewController { get }
    
    func setTitle(_ title: String) -> Self
    func setMessage(_ message: String) -> Self
    func setPreferredStyle(_ style: UIAlertController.Style) -> Self
    func setOkActionTitle(_ title: String) -> Self
    func setOkActionStyle(_ style: UIAlertAction.Style) -> Self
    func setOkAction(_ action: @escaping ((UIAlertAction) -> Void)) -> Self
    func setCencelActionTitle(_ title: String) -> Self
    func setCencelActionStyle(_ style: UIAlertAction.Style) -> Self
    func setCencelAction(_ action: @escaping ((UIAlertAction) -> Void)) -> Self
    func show()
}

final class AlertBuilder: AlertBuilderable {
    var alert = Alert()
    var alertOkAction = AlertAction()
    var alertCancelAction = AlertAction()
    var targetViewController: UIViewController
    
    init(viewController: UIViewController) {
        targetViewController = viewController
    }
    
    func setTitle(_ title: String) -> Self {
        alert.title = title
        return self
    }
    
    func setMessage(_ message: String) -> Self {
        alert.message = message
        return self
    }
    
    func setPreferredStyle(_ style: UIAlertController.Style) -> Self {
        alert.preferredStyle = style
        return self
    }
    
    func setOkActionTitle(_ title: String) -> Self {
        alertOkAction.title = title
        return self
    }
    
    func setOkActionStyle(_ style: UIAlertAction.Style) -> Self {
        alertOkAction.alertActionStyle = style
        return self
    }
    
    func setOkAction(_ action: @escaping ((UIAlertAction) -> Void)) -> Self {
        alertOkAction.action = action
        return self
    }
    
    func setCencelActionTitle(_ title: String) -> Self {
        alertCancelAction.title = title
        return self
    }
    
    func setCencelActionStyle(_ style: UIAlertAction.Style) -> Self {
        alertCancelAction.alertActionStyle = style
        return self
    }
    
    func setCencelAction(_ action: @escaping ((UIAlertAction) -> Void)) -> Self {
        alertCancelAction.action = action
        return self
    }
    
    func show() {
        let alert = UIAlertController(title: alert.title, message: alert.message, preferredStyle: alert.preferredStyle)
        
        if alertOkAction.title != nil {
            let action = UIAlertAction(title: alertOkAction.title, style: alertOkAction.alertActionStyle, handler: alertOkAction.action)
            alert.addAction(action)
        }
        
        if alertCancelAction.title != nil {
            let action = UIAlertAction(title: alertCancelAction.title, style: alertCancelAction.alertActionStyle, handler: alertCancelAction.action)
            alert.addAction(action)
        }
        
        targetViewController.present(alert, animated: true)
    }
}
