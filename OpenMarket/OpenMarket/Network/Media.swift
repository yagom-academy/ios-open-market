//
//  Media.swift
//  OpenMarket
//
//  Created by 박태현 on 2021/08/13.
//

import UIKit

enum MimeType: CustomStringConvertible {
    case jpeg
    case png

    var description: String {
        switch self {
        case .jpeg:
            return "image/jpeg"
        case .png:
            return "image/png"
        }
    }
}

struct Media {
    let key: String
    let filename: String
    let data: Data
    let mimeType: MimeType

    init?(image: UIImage, mimeType: MimeType) {
        self.key = "images[]"
        self.mimeType = mimeType

        switch mimeType {
        case .jpeg:
            self.filename = "\(arc4random()).jpeg"
            guard let data = image.jpegData(compressionQuality: 0.7) else {
                return nil
            }
            self.data = data
        case .png:
            self.filename = "\(arc4random()).png"
            guard let data = image.pngData() else { return nil }
            self.data = data
        }
    }
}
