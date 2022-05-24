//
//  NetworkError.swift
//  OpenMarket
//
//  Created by marlang, Taeangel on 2022/05/12.
//

enum NetworkError: Error {
    case unknownError
    case statusCodeError
    case decodeError
    case urlError
    case clientError
    case dataError
    case imageError
}
