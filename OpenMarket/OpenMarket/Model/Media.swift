//
//  imageData.swift
//  OpenMarket
//
//  Created by tae hoon park on 2021/08/31.
//

import UIKit

struct Media {
    let key: String = "images[]"
    let fileName: String
    let data: Data
    let mimeType: MimeType
    
    init?(image: UIImage, mimeType: MimeType) {
        switch mimeType {
        case .jpeg:
            guard let data = image.jpegData(compressionQuality: 0.7) else { return nil }
            self.data = data
            self.fileName = "\(Date()).jpeg"
        case .png:
            guard let data = image.pngData() else { return nil }
            self.data = data
            self.fileName = "\(Date()).png"
        }
        
        self.mimeType = mimeType
    }
}
