//
//  UIImage+Extension.swift
//  OpenMarket
//
//  Created by Kyo, LJ on 2022/12/03.
//

import UIKit

extension UIImage {
    func compressTo(expectedSizeInKb:Int) -> Data? {
        let sizeInBytes = expectedSizeInKb * 1024
        var needCompress:Bool = true
        var imgData:Data?
        var compressingValue:CGFloat = 1.0

        while (needCompress && compressingValue > 0.0) {
            if let data:Data = self.jpegData(compressionQuality: compressingValue) {
                if data.count < sizeInBytes {
                    needCompress = false
                    imgData = data
                } else {
                    compressingValue -= 0.1
                }
            }
        }
        if let data = imgData {
            if (data.count < sizeInBytes) {
                return data
            }
        }
        return nil
    }
    
    func resize(expectedSizeInKb:Int) -> Data? {
        var needCompress:Bool = true
        var nowWidth: CGFloat = self.size.width
        let sizeInBytes = expectedSizeInKb * 1024
        
        guard var data:Data = self.jpegData(compressionQuality: 1.0) else { return nil }
        
        while (needCompress && data.count > sizeInBytes) {
            let scale = nowWidth / self.size.width
            let nowHeight = self.size.height * scale
            if data.count < sizeInBytes {
                needCompress = false
                
            } else {
                nowWidth = nowWidth / 10
                let size = CGSize(width: nowWidth, height: nowHeight)
                let render = UIGraphicsImageRenderer(size: size)
                
                let renderImage = render.image { context in
                    self.draw(in: CGRect(origin: .zero, size: size))
                }
                
                data = renderImage.jpegData(compressionQuality: 1.0)!
            }
        }
        
        return data
    }
}
