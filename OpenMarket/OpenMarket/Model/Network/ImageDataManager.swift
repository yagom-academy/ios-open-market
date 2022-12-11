//
//  ImageDataManager.swift
//  OpenMarket
//  Created by inho, Hamo, Jeremy on 2022/12/10.
//

import UIKit

struct ImageDataManager {
    func convertImageData(_ images: [UIImage], fileName: String, mimeType: String, _ boundary: String) -> Data {
        var data = Data()
        
        images.forEach { image in
            let convertedImage = image.resizeImage(maxByte: 300000)
            data.appendString("--\(boundary)\r\n")
            data.appendString("Content-Disposition: form-data; name=\"images\"; filename=\"\(fileName)\"\r\n")
            data.appendString("Content-Type: \(mimeType)\r\n\r\n")
            data.append(convertedImage)
            data.appendString("\r\n")
        }
        
        return data
    }
}

fileprivate extension UIImage {
    func resizeImage(maxByte: Int) -> Data {
        var compressQuality: CGFloat = 1
        var imageData = Data()
        var imageByte = self.jpegData(compressionQuality: 1)?.count
        
        while imageByte! > maxByte {
            guard let jpegData = self.jpegData(compressionQuality: compressQuality) else {
                return imageData
            }
            
            imageData = jpegData
            imageByte = self.jpegData(compressionQuality: compressQuality)?.count
            compressQuality -= 0.1
        }
        
        return imageData
    }
}
