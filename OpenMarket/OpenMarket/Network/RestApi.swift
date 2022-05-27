//
//  RestApi.swift
//  OpenMarket
//
//  Created by 김동욱 on 2022/05/27.
//

import Foundation

enum RestApi {
    case get
    case post
    
    var type: String {
        switch self {
        case .get:
            return "GET"
        case .post:
            return "POST"
        }
    }
}
