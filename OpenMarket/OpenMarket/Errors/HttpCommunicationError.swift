//
//  Errors.swift
//  OpenMarket
//
//  Created by 김민성 on 2021/06/06.
//

import Foundation

enum HttpCommunicationError: LocalizedError {
    case requestError(Int)
    case serverError(Int)
    case unknownError
    
    var errorDescription: String? {
        switch self {
        case .requestError(let code):
            return "\(code) RequestError Occurred  "
        case .serverError(let code):
            return "\(code) ServerError Occurred"
        case .unknownError:
            return "UnknownError Occurred"
        }
    }
}
