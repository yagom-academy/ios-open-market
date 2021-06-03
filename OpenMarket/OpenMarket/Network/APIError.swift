//
//  NetworkError.swift
//  OpenMarket
//
//  Created by James on 2021/05/31.
//

import Foundation

public enum APIError: Error {
    case decoding, encoding, network
}
extension APIError: CustomStringConvertible {
    public var description: String {
        switch self {
        case .network:
            return "Network is not responding"
        case .decoding:
            return "Data was not decoded properly"
        case .encoding:
            return "Data was not encoded properly"
        }
    }
    
    
}
