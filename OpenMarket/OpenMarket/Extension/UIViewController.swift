//
//  UIViewController.swift
//  OpenMarket
//
//  Created by 조민호 on 2022/05/17.
//

import UIKit

protocol AlertPresentable {
    var alertBuilder: AlertBuilderable { get }
}

extension UIViewController: AlertPresentable {
    var alertBuilder: AlertBuilderable {
        AlertBuilder(viewController: self)
    }
}
