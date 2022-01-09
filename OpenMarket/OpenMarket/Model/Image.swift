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
    
}
