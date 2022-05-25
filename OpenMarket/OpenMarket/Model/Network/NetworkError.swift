//
//  NetworkError.swift
//  OpenMarket
//
//  Created by 우롱차, Donnie on 2022/05/13.
//

import Foundation

enum NetworkError: Error, LocalizedError {
    case urlError
    case sessionError
    case statusCodeError
    case dataError
}
