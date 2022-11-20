//
//  NetworkError.swift
//  OpenMarket
//  Created by inho, Hamo, Jeremy on 2022/11/15.
//

enum NetworkError: Error {
    case transportError
    case serverError
    case missingData
    case failedToParse
}
