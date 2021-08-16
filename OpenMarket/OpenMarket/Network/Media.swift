//
//  Media.swift
//  OpenMarket
//
//  Created by 박태현 on 2021/08/13.
//

import UIKit

struct Media {
    let key: String
    let filename: String
    let data: Data
    let mimeType: String
    
    init?(withImage image: UIImage, forKey key: String) {
        self.key = key
        self.mimeType = "image/png"
        self.filename = "\(arc4random()).png"
        
        guard let data = image.pngData() else { return nil }
        self.data = data
    }
}
