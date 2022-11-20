//
//  DataError.swift
//  OpenMarket
//
//  Created by Kyo, LJ on 2022/11/14.
//

import Foundation

enum NetworkError: Error {
    case empty
    case decoding
    case unknown
    case data
    case networking
    
    public var description: String {
        switch self {
        case .empty:
            return "None Data Error"
        case .decoding:
            return "Decoding Error"
        case .unknown:
            return "Unknown Error"
        case .data:
            return "Data Error"
        case .networking:
            return "Networking Error"
        }
    }
}
