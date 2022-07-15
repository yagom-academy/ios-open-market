//
//  NetworkingError.swift
//  OpenMarket
//
//  Created by minsson, yeton on 2022/07/15.
//

// MARK: - Enum

enum APIError: Error {
    case decodingJson
    case data
    case client
    case server
    case unknown
}
