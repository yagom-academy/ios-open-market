//
//  StringContainer.swift
//  OpenMarket
//
//  Created by Seungjin Baek on 2021/05/12.
//

import Foundation

enum DataTypeFormat: CustomStringConvertible {
    case MultipartFormData
    
    var description: String {
        switch self {
        case .MultipartFormData:
            return "multipart/form-data; boundary=Boundary-\(UUID().uuidString)"
        }
    }
}

enum RequestHeaderField: CustomStringConvertible {
    case ContentType
    
    var description: String {
        switch self {
        case .ContentType:
            return "Content-Type"
        }
    }
}
