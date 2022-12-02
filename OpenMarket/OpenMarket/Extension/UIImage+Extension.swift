//
//  UIImage+Extension.swift
//  OpenMarket
//
//  Created by leewonseok on 2022/12/02.
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
}
