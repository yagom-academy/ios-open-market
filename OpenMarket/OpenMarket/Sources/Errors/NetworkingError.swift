//
//  NetworkingError.swift
//  OpenMarket
//
//  Created by minsson, yeton on 2022/07/15.
//

enum NetworkingError: Error {
    case decodingJSONFailure
    case invalidURL
    case clientTransport
    case serverSideInvalidResponse
    case missingData
    case unknown
}
