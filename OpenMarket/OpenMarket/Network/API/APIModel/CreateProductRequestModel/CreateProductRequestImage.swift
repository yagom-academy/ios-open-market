//
//  Image.swift
//  OpenMarket
//
//  Created by JeongTaek Han on 2022/01/09.
//

import Foundation

struct Image {
    
    let type: ImageType
    let data: Data
    
    enum ImageType {
        case jpeg
        case png
    }
    
    init(type: ImageType, data: Data) {
        self.type = type
        self.data = data
    }
    
    init?(type: ImageType, data: Data?) {
        guard let data = data else { return nil }
        self.init(type: type, data: data)
    }
    
}
