//
//  APIError.swift
//  OpenMarket
//
//  Created by 홍정아 on 2021/08/11.
//

import Foundation

enum NetworkError: Error {
    case dataNotFound
    case invalidResponse
    case unknownError
}
