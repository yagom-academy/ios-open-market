//
//  Photo.swift
//  OpenMarket
//
//  Created by 김준건 on 2021/08/17.
//

import UIKit

struct Photo: Media {
    var key: String
    
    var fileName: String
    
    var contentType: MimeType
    
    var data: Data
    
    init?(key: String, fileName: String, contentType: MimeType, source: UIImage) {
        self.key = key
        self.fileName = fileName
        self.contentType = contentType
        
        switch contentType {
        case .pngImage:
            <#code#>
        case .jpegImage:
        default:
            return nil
        }
    }

}
