//
//  MultipartForm.swift
//  OpenMarket
//
//  Created by 이호영 on 2022/01/06.
//

import Foundation

enum MultipartForm {
    case boundary(baseBoundary: String)
    case paramsDisposition
    case imagesDisposition(filename: String)
    case imageContentType(imageType: String)
    case lastBoundary(baseBoundary: String)
    case newline
    case paramsContentType

    var string: String {
        switch self {
        case .boundary(let baseBoundary):
            return "--\(baseBoundary)\r\n"
        case .paramsDisposition:
            return "Content-Disposition: form-data; name=\"params\"\r\n"
        case .imagesDisposition(let filename):
            return "Content-Disposition: form-data; name=\"images\"; filename=\"\(filename)\"\r\n"
        case .imageContentType(let imageType):
            return "Content-Type: \(imageType)\r\n\r\n"
        case .lastBoundary(let boundary):
            return "--\(boundary)--\r\n"
        case .newline:
            return "\r\n"
        case .paramsContentType:
            return "Content-Type: application/json\r\n\r\n"
        }
    }
}
