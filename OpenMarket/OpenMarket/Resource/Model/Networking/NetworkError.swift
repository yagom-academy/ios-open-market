//
//  NetworkError.swift
//  OpenMarket
//
//  Copyright (c) 2022 Minii All rights reserved.

import Foundation

enum NetworkError: Error {
    case invalidURL
    case requestError
    case responseError
    case decodeError
}
