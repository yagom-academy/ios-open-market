//  NetworkError.swift
//  OpenMarket
//  Created by SummerCat & Bella on 2022/11/18.

import Foundation

enum NetworkError: Error {
    case statusCodeError
    case noData
    case URLError
    case decodingError
}
