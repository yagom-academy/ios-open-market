//
//  ErrorAlertProtocal.swift
//  OpenMarket
//
//  Created by 곽우종 on 2022/05/30.
//

import Foundation

protocol ErrorAlertProtocol: Error {
    static var alertTitle: String { get }
    var alertMessage: String { get }
}
