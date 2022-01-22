//
//  ImageData.swift
//  OpenMarket
//
//  Created by 권나영 on 2022/01/19.
//

import UIKit.UIImage

struct ProductImage {
    enum ImageType {
        case jpeg
        case jpg
        case png
        
        var description: String {
            switch self {
            case .jpeg:
                return ".jpeg"
            case .jpg:
                return ".jpg"
            case .png:
                return ".png"
            }
        }
    }
    
    let name: String
    let type: ImageType
    let image: UIImage
    
    var fileName: String {
        return name + type.description
    }
    
    var data: Data? {
        return image.jpegData(compressionQuality: 0.5)
    }
}
