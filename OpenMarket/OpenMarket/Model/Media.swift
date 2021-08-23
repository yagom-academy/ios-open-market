//
//  Media.swift
//  OpenMarket
//
//  Created by Do Yi Lee on 2021/08/13.
//

import UIKit

//MARK:- Media property mimeType's Type
enum MimeType: CustomStringConvertible {
    case jpeg
    case png
    
    var description: String {
        switch self {
        case .jpeg:
            return "image/jpeg"
        case .png:
            return "imgae/png"
        }
    }
}

//MARK:-NetworkManager method(createHTTPBody)'s parameter Type
struct Media {
    let key: RequestAPIKey
    let fileName: String
    let data: Data
    let mimeType: MimeType
    
    init?(image: UIImage, key: RequestAPIKey, mimeType: MimeType, fileName: String, jpegCompressionQuality: CGFloat = 0.3) {
        self.key = key
        self.mimeType = mimeType
        
        switch mimeType {
        case .jpeg:
            self.fileName = "\(fileName).jpeg"
            guard let imageData = image.jpegData(compressionQuality: jpegCompressionQuality) else {
                return nil
            }
            self.data = imageData
        case .png:
            self.fileName = "\(fileName).png"
            guard let imageData = image.pngData() else { return nil }
            self.data = imageData
        }
    }
}
