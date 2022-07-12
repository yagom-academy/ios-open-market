//
//  RequestType.swift
//  OpenMarket
//
//  Created by dhoney96 on 2022/07/12.
//

enum RequestType {
    case get
    
    var method: String {
        switch self {
        case .get:
            return "GET"
        }
    }
}
