//
//  AlertBuilder.swift
//  OpenMarket
//
//  Created by dudu, safari on 2022/05/20.
//

import UIKit

protocol AlertBuilder {
    var alertProperty: AlertProperty { get }
    var alertActionProperty: AlertActionProperty { get }
    var targetViewController: UIViewController { get }
    
    func setTitle(_ title: String) -> Self
    func setMessage(_ message: String) -> Self
    func setPreferredStyle(_ style: UIAlertController.Style) -> Self
    func setOkActionTitle(_ title: String) -> Self
    func setOkActionStyle(_ style: UIAlertAction.Style) -> Self
    func setOkAction(_ action: ((UIAlertAction) -> Void)) -> Self
    func setCencelActionTitle(_ title: String) -> Self
    func setCencelActionStyle(_ style: UIAlertAction.Style) -> Self
    func setCencelAction(_ action: ((UIAlertAction) -> Void)) -> Self
}


