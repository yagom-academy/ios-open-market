//
//  ContentType.swift
//  OpenMarket
//
//  Created by 이호영 on 2022/01/06.
//

import Foundation

enum ContentType {
    case contentType
    case json
    case formData(boundary: String)
    
    var string: String {
        switch self {
        case .contentType:
            return "Content-Type"
        case .json:
            return "application/json"
        case .formData(let boundary):
            return "multipart/form-data; boundary=\"\(boundary)\""
        }
    }
}
