//
//  Error.swift
//  OpenMarket
//
//  Created by 서녕 on 2022/01/07.
//

import Foundation

enum NetworkError: Error {
    case statusCodeError
    case unknownFailed
    case parsingFailed
}
