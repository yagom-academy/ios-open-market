//
//  NetworkError.swift
//  OpenMarket
//
//  Created by 황인우 on 2021/05/31.
//

import Foundation

public enum NetworkError: Error {
    case decoding, encoding, network
    
    var description: String {
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
