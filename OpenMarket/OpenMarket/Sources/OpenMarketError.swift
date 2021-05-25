//
//  OpenMarketError.swift
//  OpenMarket
//
//  Created by duckbok on 2021/05/18.
//

import Foundation

enum OpenMarketError: Error {
    case invalidURL
    case invalidData
    case wrongResponse
    case didNotReceivedData
    case JSONEncodingError
    case sessionError
    case bodyEncodingError
    case requestDataTypeNotMatch
    case requestGETWithData

    var description: String {
        return String(describing: self)
    }
}
