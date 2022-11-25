//
//  NetworkError.swift
//  OpenMarket
//  Created by inho, Hamo, Jeremy on 2022/11/15.
//

enum NetworkError: String, Error {
    case transportError
    case serverError
    case missingData
    case failedToParse
}
