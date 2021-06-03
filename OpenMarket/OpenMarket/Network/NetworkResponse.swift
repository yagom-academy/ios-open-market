//
//  NetworkResponse.swift
//  OpenMarket
//
//  Created by 황인우 on 2021/06/03.
//

import Foundation

enum NetworkResponseResult<String> {
    case success
    case failure(String)
}

enum NetworkResponseError: Error {
    case authenticationError, badRequest, outdated, failed, noData, unableToDecode
}
extension NetworkResponseError: CustomStringConvertible {
    var description: String {
        switch self {
        case .authenticationError:
            return "Authentication is required"
        case .badRequest:
            return "You have encountered a bad request"
        case .outdated:
            return "The Request was outdated"
        case .failed:
            return "Network request failed"
        case .noData:
            return "Response returned with no Data to decode"
        case .unableToDecode:
            return "The Request is un-decodable"
        }
    }
}
