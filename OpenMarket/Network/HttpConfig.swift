//
//  httpConfig.swift
//  OpenMarket
//
//  Created by kjs on 2021/08/16.
//

import Foundation

enum HttpConfig {
    static let multipartFormData = "multipart/form-data; boundary="
    static let applicationJson = "application/json"
    static let contentType = "Content-Type"
    static let boundaryPrefix = "--"
    static var boundary: String {
        return UUID().uuidString
    }
}


