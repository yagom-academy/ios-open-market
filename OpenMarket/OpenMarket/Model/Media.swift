//
//  Media.swift
//  OpenMarket
//
//  Created by 박태현 on 2021/08/31.
//

import UIKit

enum MimeType: CustomStringConvertible {
    case png
    case jpeg
    
    var description: String {
        switch self {
        case .png:
            return "image/png"
        case .jpeg:
            return "image/jpeg"
        }
    }
}

struct Media {
    let fieldName: String
    let fileName: String
    let mimeType: MimeType
    let fileData: Data
    
    init?(imageName: String, mimeType: MimeType, image: UIImage) {
        self.fieldName = "images[]"
        self.mimeType = mimeType
        
        switch mimeType {
        case .png:
            self.fileName = "\(imageName).png"
            guard let data = image.pngData() else {
                return nil
            }
            self.fileData = data
        case .jpeg:
            self.fileName = "\(imageName).jpeg"
            guard let data = image.jpegData(compressionQuality: 0.7) else {
                return nil
            }
            self.fileData = data
        }
    }
}
