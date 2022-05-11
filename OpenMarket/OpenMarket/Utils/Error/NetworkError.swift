//
//  NetworkError.swift
//  OpenMarket
//
//  Created by papri, Tiana on 2022/05/10.
//

import Foundation

enum NetworkError: String, Error {
    case invalidURL
    case clientError
    case serverError
}
