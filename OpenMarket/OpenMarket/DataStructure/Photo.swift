//
//  Photo.swift
//  OpenMarket
//
//  Created by 김준건 on 2021/08/17.
//

import UIKit

struct Photo: Media {
    var key: String
    var fileName: String?
    var contentType: MimeType
    var data: Data
    private let compressionRatio: CGFloat = 0.7
        
    init?(key: String, fileName: String? = nil, contentType: MimeType, source: UIImage) {
        self.key = key
        self.fileName = fileName
        self.contentType = contentType
        
        switch contentType {
        case .pngImage:
            guard let data = source.pngData() else {
                return nil
            }
            self.data = data
        case .jpegImage:
            guard let data = source.jpegData(compressionQuality: compressionRatio) else {
                return nil
            }
            self.data = data
        default:
            return nil
        }
    }

}
