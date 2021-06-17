//
//  NetworkError.swift
//  OpenMarket
//
//  Created by 김찬우 on 2021/06/08.
//

import Foundation

enum NetworkError: Error {
    case receiveNothing
    case receiveError
    case receiveUnwantedResponse
}
