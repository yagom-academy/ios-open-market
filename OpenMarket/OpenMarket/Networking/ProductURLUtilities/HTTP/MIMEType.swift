//
//  MIMEType.swift
//  OpenMarket
//
//  Created by 데릭, 수꿍.
//

import Foundation

enum MIMEType {
    case applicationJSON
    case multipartFormData
    case imageJPEG
    case contentType
    
    static let uuid = UUID()
    
    var value: String {
        switch self {
        case .applicationJSON:
            return "application/json"
        case .multipartFormData:
            return "multipart/form-data; boundary=\(MIMEType.generateBoundary())"
        case .imageJPEG:
            return "image/jpeg"
        case .contentType:
            return "Content-Type"
        }
        
    }
}

extension MIMEType {
    static func generateBoundary() -> String {
        return "Boundary-\(uuid.uuidString)"
    }
}
