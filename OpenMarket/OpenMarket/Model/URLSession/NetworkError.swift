//
//  NetworkError.swift
//  OpenMarket
//
//  Created by 써니쿠키, 메네 on 16/11/2022.
//

import Foundation

enum NetworkError: Error {
    case requestFailError
    case httpResponseError(code: Int)
    case noDataError
}
