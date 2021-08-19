//
//  ContentTypeEnum.swift
//  OpenMarket
//
//  Created by tae hoon park on 2021/08/19.
//

import Foundation

enum ContentType: CustomStringConvertible{
    case jpeg
    case png
    case json
    case multipart(boundary: String)
    
    var description: String {
        switch self {
        case .jpeg:
            return "image/jpeg"
        case .png:
            return "image/png"
        case .json:
            return "application/json"
        case .multipart(let boundary):
            return "multipart/form-data; boundary=\(boundary)"
        }
    }
}
