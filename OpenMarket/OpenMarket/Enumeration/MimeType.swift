//
//  MimeType.swift
//  OpenMarket
//
//  Created by JINHONG AN on 2021/08/17.
//

import Foundation

enum MimeType {
    case pngImage
    case jpegImage
    case multipartedFormData
    
    var format: String {
        switch self {
        case .pngImage:
            return "image/png"
        case .jpegImage:
            return "image/jpeg"
        case .multipartedFormData:
            return "multipart/form-data"
        }
    }
}
