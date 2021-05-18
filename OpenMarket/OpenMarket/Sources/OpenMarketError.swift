//
//  OpenMarketError.swift
//  OpenMarket
//
//  Created by duckbok on 2021/05/18.
//

import Foundation

enum OpenMarketError: Error, Equatable {
    case invalidURL(String)
    case invalidData(Data)
    case unauthorizedAccess
    case didNotReceivedData
    case JSONEncodingError
    case sessionError
    case bodyEncodingError
}
