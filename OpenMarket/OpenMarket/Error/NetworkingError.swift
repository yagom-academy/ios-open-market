//
//  NetworkingError.swift
//  OpenMarket
//
//  Created by yeha on 2022/01/07.
//

import Foundation

enum NetworkingError: Error {
    case request
    case response
    case data
    case decoding
    case encoding
}
