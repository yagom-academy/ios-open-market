//
//  APIError.swift
//  OpenMarket
//
//  Created by 황인우 on 2021/05/17.
//

import Foundation

enum APIError: LocalizedError {
    case invalidApproach
    var errorDescription: String? {
        "unknownError"
    }
}
