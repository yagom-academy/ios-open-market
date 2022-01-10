//
//  MultipartForm.swift
//  OpenMarket
//
//  Created by 이호영 on 2022/01/06.
//

import Foundation

enum MultipartForm {
    case boundary(baseBoundary: String)
    case contentDisposition(name: String)
    case value(_ value: Any)
    case imageContentDisposition(filename: String)
    case imageContentType(imageType: String)
    case imageValue(data: Data)
    case lastBoundary(baseBoundary: String)
    
    var string: String {
        switch self {
        case .boundary(let baseBoundary):
            return "--\(baseBoundary)\r\n"
        case .contentDisposition(let name):
            return "Content-Disposition: form-data; name=\"\(name)\"\r\n\r\n"
        case .value(let value):
            return "\(value)\r\n"
        case .imageContentDisposition(let filename):
            return "Content-Disposition: form-data; name=\"images[]\"; filename=\"\(filename)\"\r\n"
        case .imageContentType(let imageType):
            return "Content-Type: \(imageType)\r\n\r\n"
        case .imageValue(let data):
            return "\(data)\r\n"
        case .lastBoundary(let boundary):
            return "--\(boundary)--"
        }
    }
}
