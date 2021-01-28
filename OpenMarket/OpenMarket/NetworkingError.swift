//
//  NetworkingError.swift
//  OpenMarket
//
//  Created by 김동빈 on 2021/01/28.
//

import Foundation

enum NetworkingError: Error {
    case invalidURL
    case unownedError
    case failedResponse
    case noData
}
