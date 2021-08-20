//
//  Media.swift
//  OpenMarket
//
//  Created by 이예원 on 2021/08/20.
//

import UIKit

struct Media {
    let key: String
    let fileName: String
    let imageData: Data
    var mimeType: MimeType
    
    init?(image: UIImage, key: String, fileName: String, mimeType: MimeType) {
        self.key = key
        self.mimeType = mimeType
        
        switch mimeType {
        case .png:
            self.fileName = "\(fileName).png"
            guard let imageData = image.pngData() else { return nil }
            self.imageData = imageData
        }
    }
}
