//
//  RestApi.swift
//  OpenMarket
//
//  Created by 김동욱 on 2022/05/27.
//

import Foundation

enum Http {
    case get
    case post
    case patch
    
    var method: String {
        switch self {
        case .get:
            return "GET"
        case .post:
            return "POST"
        case .patch:
            return "PATCH"
        }
    }
}
