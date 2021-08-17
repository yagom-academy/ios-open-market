//
//  httpConfig.swift
//  OpenMarket
//
//  Created by kjs on 2021/08/16.
//

import Foundation

enum HttpConfig {
    static let baseURL = "https://camp-open-market-2.herokuapp.com/"
    static let invailedPath = "AppError: current path is invailed"
    static let successCode = 200...299
    
    static var bounday: String {
        return UUID().uuidString
    }
}
