//
//  AlertDelegate.swift
//  OpenMarket
//
//  Created by 박세리 on 2022/05/24.
//

import Foundation

protocol AlertDelegate: AnyObject {
    func showAlertRequestError(with error: Error)
}
