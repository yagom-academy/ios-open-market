//
//  ContentTypeEnum.swift
//  OpenMarket
//
//  Created by tae hoon park on 2021/08/19.
//

import Foundation

enum ContentType: CustomStringConvertible{
    case json
    case multipart
    
    var description: String {
        switch self {
        case .json:
            return "application/json"
        case .multipart:
            return "multipart/form-data; boundary="
        }
    }
}
