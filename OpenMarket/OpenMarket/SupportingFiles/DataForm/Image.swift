//
//  Media.swift
//  OpenMarket
//
//  Created by Luyan, Ellen on 2021/08/20.
//

import UIKit

struct Image {
    let key: String
    let data: Data
    let mimeType: String
    
    init?(withImage image: UIImage, forKey key: String) {
        self.key = key
        self.mimeType = "image/jpeg"
        guard let data = image.jpegData(compressionQuality: 0.7) else { return nil }
        self.data = data
    }
}
