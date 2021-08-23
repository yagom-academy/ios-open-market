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
    var mimeType: String
    
    init?(image: UIImage, key: String = "images[]") {
        self.key = key
        self.mimeType = "image/jpeg"
        self.fileName = "\(arc4random()).jpeg"
        
        guard let data = image.jpegData(compressionQuality: 0.5) else { return nil }
        self.imageData = data
    }
}
