//
//  Media.swift
//  OpenMarket
//
//  Created by Do Yi Lee on 2021/08/13.
//

import UIKit

struct Media {
    let key: APIKey
    let fileName: String
    let data: Data
    let mimeType: MimeType
    
    init?(image: UIImage, key: APIKey, mimeType: MimeType, fileName: String, compressionQuality: CGFloat = 0.3) {
        self.key = key
        self.mimeType = mimeType
        
        switch mimeType {
        case .jpeg:
            self.fileName = "\(fileName).jpeg"
            guard let imageData = image.jpegData(compressionQuality: compressionQuality) else {
                return nil
            }
            self.data = imageData
        case .png:
            self.fileName = "\(fileName).png"
            guard let imageData = image.pngData() else { return nil }
            self.data = imageData
        }
    }
}
