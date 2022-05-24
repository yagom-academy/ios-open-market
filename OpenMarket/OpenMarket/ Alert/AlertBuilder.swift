//
//  AlertBuilder.swift
//  OpenMarket
//
//  Created by dudu, safari on 2022/05/20.
//

import UIKit

protocol AlertBuilderable {
    var alert: Alert { get }
    var firstAction: AlertAction { get }
    var secondAction: AlertAction { get }
    var okAction: AlertAction { get }
    var cancelAction: AlertAction { get }
    var targetViewController: UIViewController { get }
    
    func setTitle(_ title: String) -> Self
    func setMessage(_ message: String) -> Self
    func setPreferredStyle(_ style: UIAlertController.Style) -> Self
    func setFirstActionTitle(_ title: String) -> Self
    func setFirstActionStyle(_ style: UIAlertAction.Style) -> Self
    func setFirstAction(_ action: @escaping ((UIAlertAction) -> Void)) -> Self
    func setSecondActionTitle(_ title: String) -> Self
    func setSecondActionStyle(_ style: UIAlertAction.Style) -> Self
    func setSecondAction(_ action: @escaping ((UIAlertAction) -> Void)) -> Self
    func setCancelButton() -> Self
    func show()
}

final class AlertBuilder: AlertBuilderable {
    var alert = Alert()
    var firstAction = AlertAction()
    var secondAction = AlertAction()
    var okAction = AlertAction()
    var cancelAction = AlertAction()
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
    
    func setFirstActionTitle(_ title: String) -> Self {
        firstAction.title = title
        return self
    }
    
    func setFirstActionStyle(_ style: UIAlertAction.Style) -> Self {
        firstAction.alertActionStyle = style
        return self
    }
    
    func setFirstAction(_ action: @escaping ((UIAlertAction) -> Void)) -> Self {
        firstAction.action = action
        return self
    }
    
    func setSecondActionTitle(_ title: String) -> Self {
        secondAction.title = title
        return self
    }
    
    func setSecondActionStyle(_ style: UIAlertAction.Style) -> Self {
        secondAction.alertActionStyle = style
        return self
    }
    
    func setSecondAction(_ action: @escaping ((UIAlertAction) -> Void)) -> Self {
        secondAction.action = action
        return self
    }
    
    func setOkButton() -> Self {
        okAction.title = "확인"
        return self
    }
    
    func setCancelButton() -> Self {
        cancelAction.title = "취소"
        cancelAction.alertActionStyle = .cancel
        return self
    }
    
    func show() {
        let alert = UIAlertController(title: alert.title, message: alert.message, preferredStyle: alert.preferredStyle)
        
        [firstAction, secondAction, okAction, cancelAction].forEach { actionButton in
            if actionButton.title != nil {
                let action = UIAlertAction(title: actionButton.title, style: actionButton.alertActionStyle, handler: actionButton.action)
                alert.addAction(action)
            }
        }
        
        targetViewController.present(alert, animated: true)
    }
}
