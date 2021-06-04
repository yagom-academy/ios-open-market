//
//  NetworkError.swift
//  OpenMarket
//
//  Created by James on 2021/05/31.
//

import Foundation

public enum DataError: Error {
    case decoding, encoding
}
extension DataError: CustomStringConvertible {
    public var description: String {
        switch self {
        case .decoding:
            return "Data was not decoded properly"
        case .encoding:
            return "Data was not encoded properly"
        }
    }
    
    
}
