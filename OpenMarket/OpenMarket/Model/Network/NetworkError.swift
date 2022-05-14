//
//  NetworkError.swift
//  OpenMarket
//
//  Created by 곽우종 on 2022/05/13.
//

import Foundation

enum NetworkError: Error, LocalizedError {
    case urlError
    case sessionError
    case statusCodeError
    case dataError
}
