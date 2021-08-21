//
//  Media.swift
//  OpenMarket
//
//  Created by Kim Do hyung on 2021/08/17.
//

import UIKit

protocol Media: Codable {
    var key: String { get set }
    var filename: String { get set }
    var data: Data { get set }
    var mimeType: String { get set }
}

struct Photo: Media {
    var key: String
    var filename: String
    var data: Data
    var mimeType: String
    
    init?(withImage image: UIImage) {
        self.key = "images[]"
        self.mimeType = "image/jpeg"
        self.filename = "photo\(arc4random()).jpeg"
        
        guard let data = image.jpegData(compressionQuality: 1) else { return nil}
        self.data = data
    }
}

