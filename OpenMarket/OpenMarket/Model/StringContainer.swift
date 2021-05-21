//
//  StringContainer.swift
//  OpenMarket
//
//  Created by Seungjin Baek on 2021/05/12.
//

import Foundation

enum StringContainer: CustomStringConvertible {
    case Error
    case NotFound404Error
    case JSONParseError
    
    var description: String {
        switch self {
        case .Error:
            return "[Error] "
        case .NotFound404Error:
            return "Cannot find data"
        case .JSONParseError:
            return "Cannot parse JSONData"
        }
    }
}
