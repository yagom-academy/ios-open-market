//
//  AlertDelegate.swift
//  OpenMarket
//
//  Created by 박세리 on 2022/05/24.
//

import Foundation

protocol MainAlertDelegate: AnyObject {
    func showAlertRequestError(with error: Error)
    func showAlertRequestDetailError(with error: Error)
}

protocol ManagingAlertDelegate: AnyObject {
    func showAlertRequestError(with error: Error)
}
