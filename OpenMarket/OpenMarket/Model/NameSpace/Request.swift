//
//  Request.swift
//  OpenMarket
//
//  Created by unchain, hyeon2 on 2022/07/30.
//

import Foundation

enum Request {
    static let identifier = "identifier"
}

enum Multipart {
    static let boundaryForm = "multipart/form-data; boundary="
    static let boundaryValue = "\(UUID().uuidString)"
    static let contentType = "Content-Type"
    static let paramContentDisposition = "Content-Disposition: form-data; name=\"params\"\r\n"
    static let paramContentType = "Content-Type: application/json\r\n\r\n"
    static let lineFeed = "\r\n"
    static let imageContentDisposition = "Content-Disposition: form-data; name=\"images\"; filename="
}

enum ImageType {
    case png
    case jpeg
    case jpg
    
    var name: String {
        switch self {
        case .png:
            return "Content-Type: image/png\r\n\r\n"
        case .jpeg:
            return "Content-Type: image/jpeg\r\n\r\n"
        case .jpg:
            return "Content-Type: image/jpg\r\n\r\n"
        }
    }
}
